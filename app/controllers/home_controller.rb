class HomeController < ApplicationController
  def index
    @accounts = Account.all
  end

  def addaccount

    account_id = add_user_account params[:username]

    add_following params[:username]
    add_followers params[:username]

    redirect_to "/home/index"

    # respond_to do |format|
    #   format.html { render :text => followers['users'].count }
    # end
  end

  def deleteall
    Follower.all.each do |follower|
      follower.destroy
    end

    Following.all.each do |following|
      following.destroy
    end

    Account.all.each do |account|
      account.destroy
    end

    redirect_to "/home/index"
  end

  def resetall
    Follower.all.each do |follower|
      follower.destroy
    end

    Following.all.each do |following|
      following.destroy
    end

    Account.all.each do |account|
      refreash_user_account account.twitter_id
      add_following account.twitter_id
      add_followers account.twitter_id
    end

    redirect_to "/home/index"
  end

  def export_edges
    @content = ''

    Follower.all.each do |follower|
      @content << '"' + follower.username + '","' + follower.account.username + '"' + "\n"
    end

    Following.all.each do |following|
      @content << '"' + following.account.username + '","' + following.username + '"' + "\n"
    end

    send_data @content,
      :type => 'text',
      :disposition => "attachment; filename=edges.csv"
  end

  private

    def add_user_account (username)
      # Now you will fetch /1.1/statuses/user_timeline.json,
      # returns a list of public Tweets from the specified
      # account.
      baseurl = "https://api.twitter.com"
      path    = "/1.1/users/show.json"
      # path    = "/1.1/followers/list.json"
      query   = URI.encode_www_form(
          "screen_name" => username,
          "count" => 200,
      )
      address = URI("#{baseurl}#{path}?#{query}")

      # Set up HTTP.
      http             = Net::HTTP.new address.host, address.port
      http.use_ssl     = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      # If you entered your credentials in the previous
      # exercise, no need to enter them again here. The
      # ||= operator will only assign these values if
      # they are not already set.
      consumer_key ||= OAuth::Consumer.new("81lKqVQwhRmmpRUk6FWvhFvF4", "cWQxoI1B9WFOPHTNTXc64zn0oOGvswpktbYeH1xqUIbjqr1EYc")
      access_token ||= OAuth::Token.new("33718717-CHcZAacLIT07lkrsb0uKxxbPFr3SFKXOqCavXKVz6", "rhHjSc3Rpk2Fl3DrgGOR5T7PfRExa9FaBs3hu0jAkLG7z")

      # Issue the request.
      request = Net::HTTP::Get.new address.request_uri
      request.oauth! http, consumer_key, access_token
      http.start
      response = http.request(request)

      i = JSON.parse(response.body)

      @twitter_account = Account.new

      @twitter_account.username = i['screen_name']
      @twitter_account.display_name = i['name']
      @twitter_account.twitter_id = i['id_str']
      @twitter_account.followers_count = i['followers_count']
      @twitter_account.following_count = i['friends_count']

      @twitter_account.save

      http.finish

      r = i['id_str']
    end

    def refreash_user_account (twitter_id)
      # Now you will fetch /1.1/statuses/user_timeline.json,
      # returns a list of public Tweets from the specified
      # account.
      baseurl = "https://api.twitter.com"
      path    = "/1.1/users/show.json"
      # path    = "/1.1/followers/list.json"
      query   = URI.encode_www_form(
          "user_id" => twitter_id,
          "count" => 200,
      )
      address = URI("#{baseurl}#{path}?#{query}")

      # Set up HTTP.
      http             = Net::HTTP.new address.host, address.port
      http.use_ssl     = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      # If you entered your credentials in the previous
      # exercise, no need to enter them again here. The
      # ||= operator will only assign these values if
      # they are not already set.
      consumer_key ||= OAuth::Consumer.new("81lKqVQwhRmmpRUk6FWvhFvF4", "cWQxoI1B9WFOPHTNTXc64zn0oOGvswpktbYeH1xqUIbjqr1EYc")
      access_token ||= OAuth::Token.new("33718717-CHcZAacLIT07lkrsb0uKxxbPFr3SFKXOqCavXKVz6", "rhHjSc3Rpk2Fl3DrgGOR5T7PfRExa9FaBs3hu0jAkLG7z")

      # Issue the request.
      request = Net::HTTP::Get.new address.request_uri
      request.oauth! http, consumer_key, access_token
      http.start
      response = http.request(request)

      i = JSON.parse(response.body)

      @twitter_account = Account.find_by twitter_id: twitter_id

      @twitter_account.username = i['screen_name']
      @twitter_account.display_name = i['name']
      @twitter_account.followers_count = i['followers_count']
      @twitter_account.following_count = i['friends_count']

      @twitter_account.save

      http.finish
    end

    def add_followers (twitter_id)
      # Now you will fetch /1.1/statuses/user_timeline.json,
      # returns a list of public Tweets from the specified
      # account.
      baseurl = "https://api.twitter.com"
      path    = "/1.1/followers/list.json"
      # path    = "/1.1/followers/list.json"

      # If you entered your credentials in the previous
      # exercise, no need to enter them again here. The
      # ||= operator will only assign these values if
      # they are not already set.
      consumer_key ||= OAuth::Consumer.new("81lKqVQwhRmmpRUk6FWvhFvF4", "cWQxoI1B9WFOPHTNTXc64zn0oOGvswpktbYeH1xqUIbjqr1EYc")
      access_token ||= OAuth::Token.new("33718717-CHcZAacLIT07lkrsb0uKxxbPFr3SFKXOqCavXKVz6", "rhHjSc3Rpk2Fl3DrgGOR5T7PfRExa9FaBs3hu0jAkLG7z")
      
      cursor = -1
      
      loop do
      
        query   = URI.encode_www_form(
            "user_id" => twitter_id,
            "count" => 200,
            "cursor" => cursor
        )
        address = URI("#{baseurl}#{path}?#{query}")

        # Set up HTTP.
        http             = Net::HTTP.new address.host, address.port
        http.use_ssl     = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        # Issue the request.
        request = Net::HTTP::Get.new address.request_uri
        request.oauth! http, consumer_key, access_token
        http.start
        response = http.request(request)

        i = JSON.parse(response.body)

        account_id = get_account_id twitter_id

        i['users'].each do |user|

            @following = Follower.new

            @following.username = user['screen_name']
            @following.display_name = user['name']
            @following.twitter_id = user['id_str']

            @following.account_id = account_id

            @following.save

        end
        
        cursor = i['next_cursor']

        http.finish
        
        break if cursor == 0
      
      end
    end

    def add_following (twitter_id)
      # Now you will fetch /1.1/statuses/user_timeline.json,
      # returns a list of public Tweets from the specified
      # account.

      # If you entered your credentials in the previous
      # exercise, no need to enter them again here. The
      # ||= operator will only assign these values if
      # they are not already set.
      consumer_key ||= OAuth::Consumer.new("81lKqVQwhRmmpRUk6FWvhFvF4", "cWQxoI1B9WFOPHTNTXc64zn0oOGvswpktbYeH1xqUIbjqr1EYc")
      access_token ||= OAuth::Token.new("33718717-CHcZAacLIT07lkrsb0uKxxbPFr3SFKXOqCavXKVz6", "rhHjSc3Rpk2Fl3DrgGOR5T7PfRExa9FaBs3hu0jAkLG7z")
      baseurl = "https://api.twitter.com"
      path    = "/1.1/friends/list.json"
      # path    = "/1.1/followers/list.json"
      
      cursor = -1
      
      loop do
      
        query   = URI.encode_www_form(
            "user_id" => twitter_id,
            "count" => 200,
            "cursor" => cursor
        )
        address = URI("#{baseurl}#{path}?#{query}")

        # Set up HTTP.
        http             = Net::HTTP.new address.host, address.port
        http.use_ssl     = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        # Issue the request.
        request = Net::HTTP::Get.new address.request_uri
        request.oauth! http, consumer_key, access_token
        http.start
        response = http.request(request)

        i = JSON.parse(response.body)

        account_id = get_account_id twitter_id

        i['users'].each do |user|

            @following = Following.new

            @following.username = user['screen_name']
            @following.display_name = user['name']
            @following.twitter_id = user['id_str']

            @following.account_id = account_id

            @following.save

        end

        http.finish
        
        cursor = i['next_cursor']
        
      end
    end

    def get_account_id (twitter_id)
      @account = Account.find_by twitter_id: twitter_id
      return @account.id
    end

end
