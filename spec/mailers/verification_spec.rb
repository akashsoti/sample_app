require "spec_helper"

describe Verification do
  describe "send_link" do
    let(:mail) { Verification.send_link }

    it "renders the headers" do
      mail.subject.should eq("Send link")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
