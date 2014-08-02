require "spec_helper"

module RSpec::Http
  describe HeaderMatchers do
    let(:response) { Rack::Response.new }
    before(:each) { response["Content-Type"] = "text/plain"}

    context "checking for the presence of a header" do
      it "passes if the header is set" do
        expect(response).to have_header("Content-Type")
      end

      it "fails if the header is not set" do
        expect(response).not_to have_header("Foobar")
      end

      it "returns an appropriate failure message in the positive case" do
        expect {
          expect(response).to have_header("Foobar")
        }.to fail_with("The header 'Foobar' was not found")
      end

      it "returns an appropriate failure message in the negative case" do
        expect {
          expect(response).not_to have_header("Content-Type")
        }.to fail_with("The header 'Content-Type' should not have been found, but it was and it has a value of 'text/plain'")
      end

      it "should be case insensitive" do
        expect(response).to have_header("Content-Type")
        expect(response).to have_header("content-type")
        expect(response).to have_header("Content-type")
        expect(response).to have_header("CONTENT-TYPE")
      end
    end

    context "checking the value of the header" do
      it "passes if the value is set correctly" do
        expect(response).to have_header("Content-Type" => "text/plain")
      end

      it "passes if matching is incasesensitve" do
        expect(response).to have_header("Content-Type" => "Text/Plain")
      end

      context "incorrect value" do
        it "fails if the value is incorrect" do
          expect(response).not_to have_header("Content-Type" => "text/csv")
        end

        it "returns an appropriate failure message in the positive case" do
          expect {
            expect(response).to have_header("Content-Type" => "text/csv")
          }.to fail_with("Expected the response header 'Content-Type' to have a value of 'text/csv' but it was 'text/plain'")
        end

        it "returns an appropriate failure message in the negative case" do
          expect {
            expect(response).not_to have_header("Content-Type" => "text/plain")
          }.to fail_with("Expected the response header 'Content-Type' to have a value that is not 'text/plain'")
        end
      end

      context "missing header" do
        it "fails if the header is missing" do
          expect(response).not_to have_header("Foobar" => "text/csv")
        end

        it "returns an appropriate failure message in the positive case" do
          expect {
            expect(response).to have_header("Foobar" => "text/csv")
          }.to fail_with("The header 'Foobar' was not found")
        end
      end
    end

    context "comparing the value to a regex" do
      it "passes if the value is set correctly" do
        expect(response).to have_header("Content-Type" => /plain/)
      end

      context "incorrect value" do
        it "fails if the value is incorrect" do
          expect(response).not_to have_header("Content-Type" => /csv/)
        end

        it "returns an appropriate failure message in the positive case" do
          expect {
            expect(response).to have_header("Content-Type" => /csv/)
          }.to fail_with("Expected the response header 'Content-Type' to have a value that matched /csv/ but it was 'text/plain'")
        end

        it "returns an appropriate failure message in the negative case" do
          expect {
            expect(response).not_to have_header("Content-Type" => /plain/)
          }.to fail_with("Expected the response header 'Content-Type' to have a value that does not match /plain/ but it was 'text/plain'")
        end
      end

      context "missing header" do
        it "fails if the header is missing" do
          expect(response).not_to have_header("Foobar" => /csv/)
        end

        it "returns an appropriate failure message in the positive case" do
          expect {
            expect(response).to have_header("Foobar" => "text/csv")
          }.to fail_with("The header 'Foobar' was not found")
        end
      end

      it "fails if the value is something other than a String or Regexp" do
        expect {
          expect(response).to have_header("Content-Type" => [])
        }.to raise_error(SyntaxError, 'The value for a header should be either a String or a Regexp and not of type Array')
      end
    end
  end
end
