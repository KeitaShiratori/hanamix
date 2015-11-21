$ ->
  # コントローラーとアクションに対応する処理だけを実行する
  $body = $("body")
  controller = $body.data("controller")
  action = $body.data("action")
  
  if window[controller]
    activeController = new window[controller]

    if activeController && $.isFunction(activeController[action])
      activeController[action]()
