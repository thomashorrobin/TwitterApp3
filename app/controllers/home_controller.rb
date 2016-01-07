class HomeController < ApplicationController
  def index
    @accounts = Account.all
  end

  def addaccount
    # Now you will fetch /1.1/statuses/user_timeline.json,
    # returns a list of public Tweets from the specified
    # account.
    baseurl = "https://api.twitter.com"
    path    = "/1.1/users/show.json"
    # path    = "/1.1/followers/list.json"
    query   = URI.encode_www_form(
        "screen_name" => params[:username],
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
    @twitter_account.followers = i['followers_count']
    @twitter_account.following = i['friends_count']

    @twitter_account.save

    http.finish

    path    = "/1.1/friends/list.json"
    address = URI("#{baseurl}#{path}?#{query}")

    request = Net::HTTP::Get.new address.request_uri
    request.oauth! http, consumer_key, access_token
    http.start
    response = http.request(request)

    following = JSON.parse(response.body)

    following['users'].each do |f|
      @following = Following.new

      @following.username = f['screen_name']
      @following.display_name = f['name']
      @following.twitter_id = f['id_str']

      @following.account_id = @twitter_account.id

      @following.save
    end

    http.finish

    path    = "/1.1/followers/list.json"
    address = URI("#{baseurl}#{path}?#{query}")

    request = Net::HTTP::Get.new address.request_uri
    request.oauth! http, consumer_key, access_token
    http.start
    response = http.request(request)

    followers = JSON.parse(response.body)

    followers['users'].each do |f|
      @follower = Follower.new

      @follower.username = f['screen_name']
      @follower.display_name = f['name']
      @follower.twitter_id = f['id_str']

      @follower.account_id = @twitter_account.id

      @follower.save
    end

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
    respond_to do |format|
      format.html { render :text => "reset all" }
    end
  end

  def export_edges
    @content = "Hello World\n"
    @content << "new line\n"
    @content << "new line\n"
    @content << "new line\n"
    send_data @content,
      :type => 'text',
      :disposition => "attachment; filename=your_file_name.txt"
  end

  def export_nodes
    respond_to do |format|
      format.html { render :text => "export nodes" }
    end
  end

  private

    def add_user_account
      # Now you will fetch /1.1/statuses/user_timeline.json,
      # returns a list of public Tweets from the specified
      # account.
      baseurl = "https://api.twitter.com"
      path    = "/1.1/users/show.json"
      # path    = "/1.1/followers/list.json"
      query   = URI.encode_www_form(
          "screen_name" => params[:username],
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
      @twitter_account.followers = i['followers_count']
      @twitter_account.following = i['friends_count']

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
      @twitter_account.followers = i['followers_count']
      @twitter_account.following = i['friends_count']

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

      http.finish
    end

    def add_following (twitter_id)
      # Now you will fetch /1.1/statuses/user_timeline.json,
      # returns a list of public Tweets from the specified
      # account.
      baseurl = "https://api.twitter.com"
      path    = "/1.1/friends/list.json"
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

      http.finish
    end

end
