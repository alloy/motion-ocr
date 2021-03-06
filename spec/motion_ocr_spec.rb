# encoding: UTF-8

describe Motion::OCR do

  it "can detect the text in the sample image" do
    ocr = Motion::OCR.new

    ocr.scan(image 'phototest').should == <<-EOF.gsub(/^\W\W+/, '')
      This is a lot of 12 point text to test the
      ocr code and see if it works on all types
      of file format.
      The quick brown dog jumped over the
      lazy fox. The quick brown dog jumped
      over the lazy fox. The quick brown dog
      jumped over the lazy fox. The quick
      brown dog jumped over the lazy fox.

    EOF
  end

  it "accepts the language as parameter" do
    install_language :deu
    ocr = Motion::OCR.new language: "deu"

    ocr.scan(image 'phototest_german').should == <<-EOF.gsub(/^\W\W+/, '')
      Weit hinten, hinter den Wortbergen,
      fern der Länder Vokalien und Konsonantien
      leben die Blindtexte.
      Abgeschieden wohnen sie in Buchstabhausen
      an der Küste des Semantik,
      eines großen Sprachozeans.
      Ein kleines Bächlein namens Duden
      fließt durch ihren Ort
      und versorgt sie mit den nötigen Regelialien.

    EOF
  end

  it "can produce hocr output" do
    ocr = Motion::OCR.new

    hocr = ocr.scan image('phototest'), format: :hocr
    hocr.match %r{<span class='ocrx_word'[^>]*>(\w+)</span>}
    $1.should == "This"
  end

  it "still works with the old constructor" do
    ocr = MotionOCR.new

    ocr.scan(image 'phototest').should == <<-EOF.gsub(/^\W\W+/, '')
      This is a lot of 12 point text to test the
      ocr code and see if it works on all types
      of file format.
      The quick brown dog jumped over the
      lazy fox. The quick brown dog jumped
      over the lazy fox. The quick brown dog
      jumped over the lazy fox. The quick
      brown dog jumped over the lazy fox.

    EOF
  end

  def image(image_name)
    UIImage.imageWithContentsOfFile(file("#{image_name}.gif")).CGImage
  end

  def file(file_name)
    File.expand_path("../support/#{file_name}", __FILE__)
  end

  def install_language(language)
    documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)
    targetPath = "#{documentPaths.first}/tessdata/#{language}.traineddata"
    fileManager = NSFileManager.defaultManager
    fileManager.copyItemAtPath file("#{language}.traineddata"), toPath: targetPath, error: nil
  end
end
