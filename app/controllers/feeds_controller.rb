class FeedsController < ApplicationController
  
  def index
    @feeds = Feed.all
    @entries = Entry.order("created_at DESC").first(10)
  end

  def create
    url = params[:feed][:feed_url]
    url = url.strip and url = url.gsub(/\A.*\/\//,"")
    created_feed = Feedzirra::Feed.fetch_and_parse(url)

    redirect_to :back and return if Feed.exists? feed_url: created_feed.feed_url

    @feed = Feed.new
    @feed.fetch_feed_data created_feed
    @feed.save
    @feed.first_update_entries created_feed
    redirect_to :back
  end

  def show
    feed = Feed.find_by_id(params[:id])
    #feed.update_entries
    @entries = feed.entries.order("created_at DESC").first(20)
    @feeds = Feed.all
    render :index
  end

end
