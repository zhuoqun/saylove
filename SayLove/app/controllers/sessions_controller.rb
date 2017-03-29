class SessionsController < ApplicationController
  def create
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  def oauth_success
    provider_name = params[:provider]
    raw_info = request.env["omniauth.auth"][:extra][:raw_info]
    oauth_token = request.env["omniauth.auth"][:credentials][:token]
    #"omniauth.auth"=>#<OmniAuth::AuthHash credentials=#<Hashie::Mash expires=true expires_at=1345149696 token="2ea671622bf3eb218bf3542683dbc163">

    uid = raw_info[:id]

    user_info = {}

    case provider_name
    when 'douban'
      #<Hashie::Mash alt="http://www.douban.com/people/DreamerWang/" avatar="http://img3.douban.com/icon/u1534763-9.jpg" created="2007-04-30 22:14:44" desc="Talk is cheap. Real artists ship.\n\nhttp://www.zhuoqun.net" id="1534763" loc="北京" name="zhuoqun" status="self" uid="DreamerWang">
      #
      user_info[:user_name] = raw_info[:name]
      user_info[:gender] = -1
      user_info[:avatar] = raw_info[:avatar]

      user_info[:uid] = raw_info[:id]
      user_info[:url] = raw_info[:alt]

    when 'weibo'
      #<Hashie::Mash allow_all_act_msg=false allow_all_comment=true avatar_large="http://tp2.sinaimg.cn/1661293025/180/5635994420/1" bi_followers_count=208 city="8" created_at="Mon Nov 16 11:53:45 +0800 2009" description="有梦想，不抱怨。" domain="zhuoqun" favourites_count=509 follow_me=false followers_count=1598 following=false friends_count=312 gender="m" geo_enabled=true id=1661293025 idstr="1661293025" lang="zh-cn" location="北京 海淀区" name="zhuoqun" online_status=0 profile_image_url="http://tp2.sinaimg.cn/1661293025/50/5635994420/1" profile_url="zhuoqun" province="11" remark="" screen_name="zhuoqun" 

      user_info[:user_name] = raw_info[:screen_name]

      gender = {'m' => 1, 'f' => 0, 'n' => -1}
      user_info[:gender] = gender[raw_info[:gender]]

      user_info[:avatar] = raw_info[:avatar_large]

      user_info[:uid] = raw_info[:id]
      user_info[:url] = 'http://weibo.com/' + raw_info[:profile_url]

    end

    auth_provider = Provider.find_by_provider_and_uid(provider_name, uid)

    if (auth_provider.present?)
      # If already authed
      user = auth_provider.user
      user.user_name = user_info[:user_name]
      user.avatar = user_info[:avatar]
      user.gender = user_info[:gender]
      user.save

      auth_provider.uid = user_info[:uid]
      auth_provider.url = user_info[:url]
      auth_provider.save

    else
      user = User.new
      provider = Provider.new

      user.user_name = user_info[:user_name]
      user.avatar = user_info[:avatar]
      user.gender = user_info[:gender]
      user.save

      provider.user_id = user.id
      provider.provider = provider_name
      provider.token = oauth_token
      provider.uid = user_info[:uid]
      provider.url = user_info[:url]
      provider.save

    end

    session[:user_id] = user.id

    redirect_back_or(root_url)

  end

  def oauth_failure
    redirect_back_or(root_url)
  end
end
