S3FS = require "../main"
S3Uploader = require "s3-uploader"

describe "S3FS", ->
  it "should be able to load an index", (done) ->
    uploader = S3Uploader(JSON.parse(localStorage.FSPolicy))

    S3FS.create(uploader).then (fs) ->
      fs.write("test.wat", "butts").then ->
        fs.persist().then (sha) ->
          done()
    .done()

  it "should be able to read a file", (done) ->
    uploader = S3Uploader(JSON.parse(localStorage.FSPolicy))
    
    S3FS.mount("92a9e91058fd8d2cd00a6b5865897656d9ed080c", uploader).then (fs) ->
      fs.read("test.wat").then (text) ->
        assert.equal text, "butts"
        done()
    .done()
