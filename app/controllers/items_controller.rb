class ItemsController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_filter :authenticate_user!, :except => [:index]

  def new
    @item = Item.new
  end

  def create
    list = List.find(params[:item][:list_id])
    @item = Item.new(:name => params[:item][:name], :initial_comment => params[:item][:initial_comment], :wishlist => params[:item][:wishlist])
    @item.list = list
    @item.location_name = params[:item][:location_name]
    @item.category_name = params[:item][:category_name]
    @item.url = params[:item][:url]
    @item.api = params[:item][:api]    
    @item.image = params[:item][:image]    

    authorize! :create, @item
    respond_to do |format|
      if @item.save
        if !params[:item][:category_name].blank?
          list.tag_list.push(params[:item][:category_name])
        end
        if !params[:item][:location_name].blank?
          list.tag_list.push(params[:item][:location_name])
        end
        list.save

        format.html
        format.json
        format.js {render :create}
      end
    end
  end

  def add
    list = current_user.lists.where("title = ?", params[:list]).first
    item = Item.find(params[:item_id])
    item_copy = Item.new(:name => item.name, :initial_comment => params[:initial_comment])
    item_copy.list = list
    item_copy.location_name = item.location_name
    item_copy.category_name = item.category_name
    item_copy.url = item.url
    item_copy.api = item.api
    item_copy.image = item.image
    item_copy.save

        if item_copy.category
          list.tag_list.push(item_copy.category_name)
        end
        if item_copy.location
          list.tag_list.push(item_copy.location_name)
        end
        list.save

    respond_to do |format|


        format.html
        format.json
        format.js {render :add}
      end
    
  end

  def edit
  end

  def update
  end

  def destroy
    @item = Item.find(params[:id])
    authorize! :destroy, @item
    @item.destroy
    flash[:success] = "Item deleted."
    respond_to do |format|
      format.html {redirect_to user_path(current_user)}
      format.js
    end
  end

  def index

    location = ERB::Util.url_encode(params[:location])
    term = ERB::Util.url_encode(params[:term])
  
    #create friend's items for autocomplete

    businesses_response = []
    
    if not location.blank?
      #YELP

      consumer_key = '7RYTwy6YE2Ml3xns_WyENQ'
      consumer_secret = '-lZovlfphg7Y0EVLPqw9cOzp5dg'
      token = 'lcY-UHpnqPxT2EmHb9IEKTfK8RS6s7x9'
      token_secret = 'IEN-REYWBKyUndjkY6uHE2AvcZc'

      api_host = 'api.yelp.com'

      consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
      access_token = OAuth::AccessToken.new(consumer, token, token_secret)

      path = "/v2/search?term=#{term}&location=#{location}&limit=10"
      puts path

      response_body = access_token.get(path).body
      #puts response_body
      businesses = JSON.parse(response_body)["businesses"]
      businesses_response = businesses.map{|b| {"label" => b["name"], "url" => b["url"] ,"category" => b["categories"][0][0], "api" => "Yelp", "image" => b["image_url"] }}
      #businesses_response.push({"label" => "Back to the Future", "url" => "XX", "category" => "Sci Fi", "api" => "Amazon"})

    else
      #AMAZON

      #ASSOCIATES_ID = ""
      #key_id = "AKIAICXKUN6S6AQBWWJA"
      #il = Amazon::AWS::ItemLookup.new( 'ASIN', { 'ItemId' => 'B001COU9I6', 'MerchantId' => 'Amazon' })
      #rg = Amazon::AWS::ResponseGroup.new( 'Medium' )
      ##req = Request.new(KEY_ID, ASSOCIATES_ID)
      #req =  Amazon::AWS::Search::Request.new(key_id)
      #resp = req.search( il, rg)
      #item_sets = resp.item_lookup_response[0].items
      #puts item_sets


      # create an ASIN client
      client = ASIN::Client.instance

      # lookup an item with the amazon standard identification number (asin)
      #items = client.lookup '1430218150'

      #items = client.search_keywords term
      items = client.search :Keywords => term, :SearchIndex => :Books, :Sort => 'relevancerank', :ResponseGroup => :Medium

      items.each do |i|
        if i.raw.MediumImage.nil?
          businesses_response.push({ "label" => truncate(i.raw.ItemAttributes.Title, :length => 50, :omission =>"..."), "url" => i.raw.DetailPageURL, "category" => i.raw.ItemAttributes.ProductGroup, "image" => "", "api" => "Amazon"  })
        else
          businesses_response.push({ "label" => truncate(i.raw.ItemAttributes.Title, :length => 50, :omission =>"..."), "url" => i.raw.DetailPageURL, "category" => i.raw.ItemAttributes.ProductGroup, "image" => i.raw.MediumImage.URL, "api" => "Amazon"  })
        end
      end

      items = client.search :Keywords => term, :SearchIndex => :DVD, :Sort => 'relevancerank', :ResponseGroup => :Medium

      items.each do |i|
        if i.raw.MediumImage.nil?
          businesses_response.push({ "label" => truncate(i.raw.ItemAttributes.Title, :length => 50, :omission =>"..."), "url" => i.raw.DetailPageURL, "category" => i.raw.ItemAttributes.ProductGroup, "image" => "", "api" => "Amazon"  })
        else
          businesses_response.push({ "label" => truncate(i.raw.ItemAttributes.Title, :length => 50, :omission =>"..."), "url" => i.raw.DetailPageURL, "category" => i.raw.ItemAttributes.ProductGroup, "image" => i.raw.MediumImage.URL, "api" => "Amazon"  })
        end
      end

      items = client.search :Keywords => term, :SearchIndex => :Music, :Sort => 'psrank', :ResponseGroup => :Medium

      items.each do |i|
        if i.raw.MediumImage.nil?
          businesses_response.push({ "label" => truncate(i.raw.ItemAttributes.Title, :length => 50, :omission =>"..."), "url" => i.raw.DetailPageURL, "category" => i.raw.ItemAttributes.ProductGroup, "image" => "", "api" => "Amazon"  })
        else
          businesses_response.push({ "label" => truncate(i.raw.ItemAttributes.Title, :length => 50, :omission =>"..."), "url" => i.raw.DetailPageURL, "category" => i.raw.ItemAttributes.ProductGroup, "image" => i.raw.MediumImage.URL, "api" => "Amazon"  })
        end
      end

      items = client.search :Keywords => term, :SearchIndex => :VideoGames, :Sort => 'salesrank', :ResponseGroup => :Medium

      items.each do |i|
        if i.raw.MediumImage.nil?
          businesses_response.push({ "label" => truncate(i.raw.ItemAttributes.Title, :length => 50, :omission =>"..."), "url" => i.raw.DetailPageURL, "category" => i.raw.ItemAttributes.ProductGroup, "image" => "", "api" => "Amazon"  })
        else
          businesses_response.push({ "label" => truncate(i.raw.ItemAttributes.Title, :length => 50, :omission =>"..."), "url" => i.raw.DetailPageURL, "category" => i.raw.ItemAttributes.ProductGroup, "image" => i.raw.MediumImage.URL, "api" => "Amazon"  })
        end
      end

    end

    businesses_response.sort!{|a,b| a["category"].downcase <=> b["category"].downcase}

    #@locations = Location.order(:name).where("name like ?", "%#{params[:term]}%")
    #render json: @locations.map(&:name)
    #@items = [Item.new(name:"test1"), Item.new(name:"test2")]
    render json: businesses_response#@items.map(&:name)



  end

  def show
    @item = Item.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end
end
