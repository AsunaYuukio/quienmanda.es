require 'spec_helper'

describe SvgRendersController do
  context "with given svg content" do
    it "should convert it into jpg file and return url to it" do
      File.rename "#{Rails.root}/public/uploads", "#{Rails.root}/public/uploads_orig"
      Dir.mkdir "#{Rails.root}/public/uploads"
      begin
        post :create, svg: '<svg width="861.6666666269302" height="484.68749997764826"><g><defs><marker id="relation" viewBox="0 -5 15 10" refX="20" refY="-0.5" markerWidth="5" markerHeight="5" orient="auto"><path d="M0,-5L10,0L0,5"></path></marker></defs><g id="linksContainer"><path class="link" marker-end="url(#relation)" d="M430.8333333134651,242.34374998882413A160.53053317670177,160.53053317670177 0 0,1 486.65260764924506,333.6540182696375"></path><path class="link" marker-end="url(#relation)" d="M430.8333333134651,242.34374998882413A160.51245480546834,160.51245480546834 0 0,1 390.49342412897107,143.23033676180367"></path></g><g id="nodesContainer"><g class="node root" transform="translate(430.8333333134651,242.34374998882413)"><circle r="9" style="fill: rgb(7, 80, 122);"></circle><image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/img/plus-sign.png" x="-8" y="-8" class="expand-icon" width="16" height="16"></image><text dx="11" dy=".35em">Janusz Józef Śniadek</text></g><g class="node" transform="translate(486.65260764924506,333.6540182696375)"><circle r="9" style="fill: rgb(48, 125, 172);"></circle><image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/img/plus-sign.png" x="-8" y="-8" class="expand-icon" width="16" height="16"></image><text dx="11" dy=".35em">FUNDACJA JANA PIETRZAKA "TOWARZYSTWO PATRIOTYCZNE"</text></g><g class="node" transform="translate(390.49342412897107,143.23033676180367)"><circle r="9" style="fill: rgb(48, 125, 172);"></circle><image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="/img/plus-sign.png" x="-8" y="-8" class="expand-icon" width="16" height="16"></image><text dx="11" dy=".35em">FUNDACJA OCHRONY ZDROWIA W GDYNI</text></g></g></g></svg>'
        url = JSON.parse(response.body)["url"]
        expect(File.exists? "#{Rails.root}/public/#{url.gsub(/uploads.*/).first}").to be_true
      ensure
        require 'fileutils'
        FileUtils.rm_rf "#{Rails.root}/public/uploads"
        File.rename "#{Rails.root}/public/uploads_orig", "#{Rails.root}/public/uploads"
      end
    end
  end
end
