S3FS = require "../main"
S3Uploader = require "s3-uploader"

describe "S3FS", ->
  it "should be able to load an index", (done) ->
    uploader = S3Uploader(JSON.parse(localStorage.FSPolicy))

    S3FS.create(uploader).then (fs) ->
      fs.write("test.wat", "butts").then ->
        fs.persist().then (sha) ->
          console.log sha
          done()
    .done()
