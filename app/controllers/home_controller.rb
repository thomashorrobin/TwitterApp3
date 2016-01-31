class HomeController < ApplicationController

  @rate_limit_hit = false

  def index
    @accounts = Account.all
  end

  def addaccount

    account = Account.find_by username: params[:username]

    account_doesnt_exisits = account == nil

    # logger.log account_doesnt_exisits

    if account_doesnt_exisits

        account_id = add_user_account params[:username]

        add_following params[:username]
        add_followers params[:username]

        if @rate_limit_hit
            rate_limit_hit_return
        else
            redirect_to "/home/index"
        end

    else

        respond_to do |format|
            format.html { render :text => "account " + params[:username] + " already exisits" }
        end

    end

    # respond_to do |format|
    #   format.html { render :text => account_id }
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

  def export_all_edges
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

  def export_selected_edges
    @accounts = Account.all
  end

  def export_selected_edges_file
    @content = ''

    Follower.where({ account_id: params[:accounts] }).each do |follower|
      @content << '"' + follower.username + '","' + follower.account.username + '"' + "\n"
    end

    Following.where({ account_id: params[:accounts] }).each do |following|
      @content << '"' + following.account.username + '","' + following.username + '"' + "\n"
    end

    send_data @content,
      :type => 'text',
      :disposition => "attachment; filename=edges.csv"

    # respond_to do |format|
    #   format.html { render :text => params[:accounts] }
    # end
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
            "screen_name" => twitter_id,
            "count" => 200,
            "cursor" => cursor
        )
        address = URI("#{baseurl}#{path}?#{query}")

        logger.debug address

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

        if i['errors'] != nil
            @rate_limit_hit = true
            break
        end

        account_id = get_account_id twitter_id

        i['users'].each do |user|

            @follower = Follower.new

            @follower.username = user['screen_name']
            @follower.display_name = user['name']
            @follower.twitter_id = user['id_str']

            @follower.account_id = account_id

            @follower.save

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
            "screen_name" => twitter_id,
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

        if i['errors'] != nil
            @rate_limit_hit = true
            break
        end

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

        break if cursor == 0

      end
    end

    def get_account_id (twitter_id)
      @account = Account.find_by username: twitter_id
      return @account.id
    end

    def rate_limit_hit_return
        respond_to do |format|
            format.html { render :text => "unfortunately you have hit the Twitter API rate limit" }
        end
    end

end
