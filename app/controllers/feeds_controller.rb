class FeedsController < ApplicationController
  def index
    @feeds = Feed.all
    @entries = Entry.paginate(:page => params[:page], :per_page => 7).order("published DESC")
  end

  def create
    url = params[:feed][:feed_url]
    url = url.strip and url = url.gsub(/\A.*\/\//,"")
    created_feed = Feedzirra::Feed.fetch_and_parse(url)

    redirect_to :back and return if !(created_feed.respond_to?(:feed_url)) or Feed.exists? feed_url: created_feed.feed_url

    @feed = Feed.new
    @feed.fetch_feed_data created_feed
    @feed.save
    @feed.first_update_entries created_feed
    redirect_to :back
  end

  def show
    feed = Feed.find_by_id(params[:id])
    @feeds = Feed.all
    #feed.update_entries
    if feed.entries.first.published.nil?
       @entries = feed.entries.paginate(:page => params[:page], :per_page => 7).order("created_at DESC")
     else
       @entries = feed.entries.paginate(:page => params[:page], :per_page => 7).order("published DESC")
    end
    render :index
  end

  def destroy
    feed = Feed.find_by_title(params[:feed][:title])
    feed.destroy unless feed.nil?
    redirect_to :root
  end
end
