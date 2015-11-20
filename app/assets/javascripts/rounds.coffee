# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class @rounds
  printProperties = (obj) ->
    properties = ''
    for prop of obj
      properties += prop + '=' + obj[prop] + '\n'
    alert properties

  # 現在地を取得し続けるためのグローバル変数
  syncerWatchPosition = 
    count: 0
    lastTime: 0

  # 失敗した時の関数
  errorFunc = (error) ->
    # エラーコードのメッセージを定義
    errorMessage = 
      0: '原因不明のエラーが発生しました…。'
      1: '位置情報の取得が許可されませんでした…。'
      2: '電波状況などで位置情報が取得できませんでした…。'
      3: '位置情報の取得に時間がかかり過ぎてタイムアウトしました…。'
    # エラーコードに合わせたエラー内容を表示
    alert errorMessage[error.code]
    return

  # オプション・オブジェクト
  optionObj = 
    'enableHighAccuracy': false
    'timeout': 1000000
    'maximumAge': 0

  BALL_NAME = [["0", "不正な値"        , "不正な値"],
               ["1", "イーシンチュウ"  , "一星球"],
               ["2", "アルシンチュウ"  , "二星球"],
               ["3", "サンシンチュウ"  , "三星球"],
               ["4", "スーシンチュウ"  , "四星球"],
               ["5", "ウーシンチュウ"  , "五星球"],
               ["6", "リュウシンチュウ", "六星球"],
               ["7", "チーシンチュウ"  , "七星球"]]

  index: ->
    $(".sample").click ()->
      $(@).hide()

  new: ->
    marker_list = new google.maps.MVCArray();

    # 成功した時の関数
    successFunc = (position) ->
      # 位置情報
      latlng = new (google.maps.LatLng)(position.coords.latitude, position.coords.longitude)
      # 地図の中心を変更
      map.centerOn latlng
      return

    handler = Gmaps.build('Google')
    map = handler.buildMap({
      provider: 
        disableDefaultUI: true
        zoom: 18
      internal: id: 'map'
    }, ->
      markers = handler.addMarkers()
      handler.bounds.extendWith markers
      handler.fitMapToBounds()
      return
    )

    default_point = new (google.maps.LatLng)(35.494317, 134.225368)
    map.centerOn default_point
    navigator.geolocation.getCurrentPosition successFunc , errorFunc , optionObj
    
    $(".sample").click ()->
      marker_list.forEach (marker, idx) ->
        marker.setMap null

      balls = []
      
      # 表示範囲を取得
      pos   = map.getServiceObject().getBounds()
      north = pos.getNorthEast().lat()
      south = pos.getSouthWest().lat()
      east  = pos.getNorthEast().lng()
      west  = pos.getSouthWest().lng()
      $(".sample-text").html("north=#{north}\nsouth=#{south}\neast=#{east}\nwest=#{west}")

      # 表示されているGoogleMapの範囲内でボールの座標をランダムに生成し、Viewのパラメータにセットする。
      for i in [1..7]
        latlng = new google.maps.LatLng(random_pos(north, south), random_pos(east, west))
        # marker
        marker = new (google.maps.Marker)(
          position: latlng
          draggable: false
          map: map.getServiceObject()
          animation: google.maps.Animation.DROP)
        marker_list.push(marker)
  
        ball = "#{BALL_NAME[i][1]},#{BALL_NAME[i][2]},#{latlng.lat()},#{latlng.lng()}"
        balls.push(ball)
        
      $("#balls").val(balls)
      
    random_pos = (p1, p2) ->
      r = Math.random() * 0.9 + 0.05
      ret = p1 * r + p2 * (1 - r)

  edit: ->

  show: ->
    currentpos = new google.maps.LatLng(35, 135)
    
    # 成功した時の関数
    successFunc = (position) ->
      # データの更新
      ++syncerWatchPosition.count
      # 処理回数
      nowTime = ~ ~(new Date / 1000)
      # UNIX Timestamp
      # 前回の書き出しから3秒以上経過していたら描写
      # 毎回HTMLに書き出していると、ブラウザがフリーズするため
      if syncerWatchPosition.lastTime + 3 > nowTime
        return false
      # 前回の時間を更新
      syncerWatchPosition.lastTime = nowTime
      # 位置情報
      currentpos = new (google.maps.LatLng)(position.coords.latitude, position.coords.longitude)
      # 地図の中心を変更
      map.centerOn currentpos
      return

    mapStyle = [{"featureType":"water","elementType":"all","stylers":[{"hue":"#0B1E0C"},{"saturation":2},{"lightness":-89},{"visibility":"simplified"}]},{"featureType":"landscape.man_made","elementType":"all","stylers":[{"hue":"#0B1E0C"},{"saturation":26},{"lightness":-91},{"visibility":"on"}]},{"featureType":"landscape.natural","elementType":"all","stylers":[{"hue":"#0B1E0C"},{"saturation":37},{"lightness":-92},{"visibility":"on"}]},{"featureType":"poi.park","elementType":"all","stylers":[{"hue":"#0B1E0C"},{"saturation":6},{"lightness":-90},{"visibility":"off"}]},{"featureType":"landscape.man_made","elementType":"all","stylers":[{"hue":"#0B1E0C"},{"saturation":26},{"lightness":-91},{"visibility":"off"}]},{"featureType":"road","elementType":"all","stylers":[{"hue":"#00FF00"},{"saturation":100},{"lightness":-22},{"visibility":"on"}]},{"featureType":"road.highway","elementType":"all","stylers":[{"hue":"#00FF00"},{"saturation":100},{"lightness":-22},{"visibility":"on"}]},{"featureType":"road.arterial","elementType":"all","stylers":[{"hue":"#00FF00"},{"saturation":100},{"lightness":-35},{"visibility":"on"}]},{"featureType":"road.local","elementType":"all","stylers":[{"hue":"#00FF00"},{"saturation":100},{"lightness":-50},{"visibility":"on"}]},{"featureType":"administrative","elementType":"all","stylers":[{"hue":"#00FF00"},{"saturation":100},{"lightness":-2},{"visibility":"off"}]},{"featureType":"poi.park","elementType":"all","stylers":[{"hue":"#00FF00"},{"saturation":100},{"lightness":-36},{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"all","stylers":[{"hue":"#00FF00"},{"saturation":100},{"lightness":50},{"visibility":"simplified"}]},{"featureType":"poi","elementType":"all","stylers":[{"hue":"#00FF00"},{"saturation":100},{"lightness":-36},{"visibility":"off"}]},{"featureType":"poi.place_of_worship","elementType":"all","stylers":[{"hue":"#00FF00"},{"saturation":100},{"lightness":-41},{"visibility":"off"}]},{"featureType":"water","elementType":"all","stylers":[]}]

    handler = Gmaps.build('Google')
    map = handler.buildMap({
      provider:
        styles: mapStyle
        disableDefaultUI: true
        disableDoubleClickZoom: true
        draggable: false
        scrollwheel: false
      internal: id: 'rader'
    }, ->
      markers = handler.addMarkers(window.hash)
      handler.bounds.extendWith markers
      handler.fitMapToBounds()
      dispLevel map.getServiceObject().getZoom()
    )
    #現在位置を取得する
    navigator.geolocation.watchPosition successFunc, errorFunc, optionObj

    dispLevel = (level) ->
      document.getElementById('zoomlevel').innerHTML = 'LEVEL:' + level
      return
    
    $(".zoom-up").click ()->
      map.getServiceObject().setZoom(map.getServiceObject().getZoom()+1)
      dispLevel map.getServiceObject().getZoom()
      
    $(".zoom-out").click ()->
      map.getServiceObject().setZoom(map.getServiceObject().getZoom()-1)
      dispLevel map.getServiceObject().getZoom()

    $(".get-ball").click ()->
      round_id = window.round_id
      user_id = window.user_id
      
      # ajaxリクエストを送信
      $.ajax
        url: "#{round_id}/score"      # 送信先
        type: 'GET'         # 送信するリクエスト
        data:               # 送信するデータ（パラメータ)。今回の場合は、params[:word] = “入力されている文字列” となる。
          lat: currentpos.lat()
          lng: currentpos.lng()
          user_id: user_id
      return

    $(".currentpos").click ()->
      navigator.geolocation.getCurrentPosition successFunc , errorFunc , optionObj
      
