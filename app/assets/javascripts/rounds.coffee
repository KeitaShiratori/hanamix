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

  index: ->

  new: ->
    handler = Gmaps.build('Google')
    map = handler.buildMap { 
        provider: 
          disableDefaultUI: true
          zoom: 18
        internal: id: 'map'
      }, ->
      if navigator.geolocation
        navigator.geolocation.getCurrentPosition onSuccess, onError
      else
        displayOnMap 35.685175, 139.7528
      return

    onSuccess = (position) ->
      displayOnMap position.coords.latitude, position.coords.longitude

    onError = (error) ->
      errorFunc error
      displayOnMap 35.685175, 139.7528
      return

    displayOnMap = (lat, lng) ->
      marker = handler.addMarker(
        lat: lat
        lng: lng
    		draggable: true	)
      handler.map.centerOn marker

      $("#r_lat").val(lat)
      $("#r_lng").val(lng)
      
      # マーカーのドロップ（ドラッグ終了）時のイベント
      handler.map.primitives().addListener marker.serviceObject, 'dragend', (ev) ->
        # イベントの引数evの、プロパティ.latLngが緯度経度。
        $("#r_lat").val(ev.latLng.lat())
        $("#r_lng").val(ev.latLng.lng())
        return
      return

    $('.address').keypress (e) ->
      if e.which == 13
        # ここに処理を記述
        return false
      return

    $('.map-search-button').click ()->
      # Address field could be multiple elements.
      address = []
      $('.address').each( ->
        address.push($(this).val())
      )
      address = address.join()

      if !address
        return #cancel if string is empty

      # Search from address
      geocoder = new google.maps.Geocoder()
      geocoder.geocode( { 'address': address }, (results, status) ->
        if status == google.maps.GeocoderStatus.OK
          location = results[0].geometry.location
          displayOnMap location.lat(), location.lng()
          $('.address').val("")
    
      ) #geocode

  edit: ->

  show: ->
