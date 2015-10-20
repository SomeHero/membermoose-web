###
!
AngularJS file upload/drop directive with http post and progress
@author  Danial  <danial.farid@gmail.com>
@version 1.1.2
###
(->
  angularFileUpload = angular.module("angularFileUpload", [])
  angularFileUpload.service "$upload", ["$http", ($http) ->
    @upload = (config) ->
      config.method = config.method or "POST"
      config.headers = config.headers or {}
      config.headers["Content-Type"] = `undefined`
      config.transformRequest = angular.identity
      formData = new FormData()
      if config.data
        for key of config.data
          formData.append key, config.data[key]
      formData.append config.fileFormDataName or "file", config.file, config.file.name
      formData["__uploadProgress_"] = (e) ->
        config.progress e  if e

      config.data = formData
      response = $http(config)
      response.abort = ->
        throw "upload is not started yet"

      formData["__setAbortFunction_"] = (fn) ->
        response.abort = fn

      response
  ]
  angularFileUpload.directive "ngFileSelect", ["$parse", "$http", ($parse, $http) ->
    (scope, elem, attr) ->
      fn = $parse(attr["ngFileSelect"])
      fileName = attr["imageName"]
      elem.bind "change", (evt) ->
        files = []
        fileList = undefined
        i = undefined
        fileList = evt.target.files
        if fileList?
          i = 0
          while i < fileList.length
            fileList.item(i).file_name = scope.imageName
            files.push fileList.item(i)
            i++
        scope.$parent.$apply ->
          fn scope.$parent,
            $files: files
            $event: evt



      elem.bind "click", ->
        @value = null

  ]
  angularFileUpload.directive "ngFileDropAvailable", ["$parse", "$http", ($parse, $http) ->
    (scope, elem, attr) ->
      if "draggable" of document.createElement("span")
        fn = $parse(attr["ngFileDropAvailable"])
        unless scope.$$phase
          scope.$apply ->
            fn scope

        else
          fn scope
  ]
  angularFileUpload.directive "ngFileDrop", ["$parse", "$http", ($parse, $http) ->
    (scope, elem, attr) ->
      if "draggable" of document.createElement("span")
        fn = $parse(attr["ngFileDrop"])
        elem[0].addEventListener "dragover", ((evt) ->
          evt.stopPropagation()
          evt.preventDefault()
          elem.addClass attr["ngFileDragOverClass"] or "dragover"
        ), false
        elem[0].addEventListener "dragleave", ((evt) ->
          elem.removeClass attr["ngFileDragOverClass"] or "dragover"
        ), false
        elem[0].addEventListener "drop", ((evt) ->
          evt.stopPropagation()
          evt.preventDefault()
          elem.removeClass attr["ngFileDragOverClass"] or "dragover"
          files = []
          fileList = evt.dataTransfer.files
          i = undefined
          if fileList?
            i = 0
            while i < fileList.length
              files.push fileList.item(i)
              i++
          scope.$apply ->
            fn scope,
              $files: files
              $event: evt


        ), false
  ]
)()
