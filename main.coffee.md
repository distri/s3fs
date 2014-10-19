S3FS
====

An S3 backed file system.

    Q = require "q"
    SHA1 = require "sha1"

    mount = (indexSHA, uploader) ->
      console.log "Mounting #{indexSHA}"
      uploader.get(indexSHA).then (blob) ->
        console.log "got: ", blob
        readAsJSON(blob).then (index) ->
          console.log "read: ", index
          persist: ->
            persist(index, uploader)

          write: (name, data) ->
            store(data, uploader).then (sha) ->
              index[name] = sha

          read: (name) ->
            sha = index[name]

            uploader.get(sha)

    # Sync index data to backing store
    persist = (index, uploader) ->
      blob = new Blob [JSON.stringify(index)], 
        type: "application/json"

      store blob, uploader

    store = (blob, uploader) ->
      if typeof blob is "string"
        blob = new Blob [blob],
          type: "text/plain"

      deferred = Q.defer()

      SHA1 blob, (sha) ->
        uploader.upload(
          key: sha
          blob: blob
          cacheControl: 31536000
        ).then ->
          deferred.resolve(sha)
        , deferred.reject
        , deferred.notify
        .done()

      return deferred.promise

    module.exports =
      create: (uploader) ->
        persist({}, uploader).then (sha) ->
          mount(sha, uploader)

      mount: mount
    
Helpers
-------

    readAsText = (blob) ->
      deferred = Q.defer()

      reader = new FileReader

      reader.onload = ->
        deferred.fulfill reader.result

      reader.onerror = (e) ->
        deferred.reject e.target.error

      reader.readAsText(blob)

      return deferred.promise

    readAsJSON = (blob) ->
      readAsText(blob).then JSON.parse
