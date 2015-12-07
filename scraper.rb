#!/usr/bin/env ruby
require 'scraperwiki'
require 'mechanize'

base_url = "http://www.armadale.wa.gov.au/out-comment"

agent = Mechanize.new
main_page = agent.get(base_url)
date_scraped = Date.today.to_s

main_page.search("/html/body/div[1]/div[4]/div/div[2]/div/div/*/*/*").each do |plan|
  if(plan.text["Proposed"]) then
    puts "PROPOSED: #{plan.text[1..50].strip}>>>>"
    description = plan.children[0].content
    on_notice_to = plan.children[3].content
    info_url = "http://www.armadale.wa.gov.au#{plan.children[6].attribute("href").value}"
#    plan.children[6].attributes.each do |a|
#      puts "     a:#{a}"
#    end
  else if (plan.text == "Notices" || plan.text == "The following items are not currently out for comment and are being provided purely for informational purposes at this stage.")
#    puts "\nSKIP HEADER:\n"
  else
    puts "OTHER:#{plan.text[1..50].strip}>>>>"
    info_url = plan.children[3].content
    description = plan.children[1].content
#    plan.children.each do |child|
#      puts " -c- : #{child.text.strip}"
#    end
  end end

## Bastards! ... there is no council reference to scrape!!!

  address_description = ""
  comment_url = ""
  record = {
		'council_reference' => "",
		'address' => "",
		'description' => description,
		'info_url' => info_url,
		'comment_url' => comment_url,
		'date_scraped' => date_scraped,
		'on_notice_to' => on_notice_to

  }
  puts "   record:"
  puts "   #{record}\n"

#	if (ScraperWiki.select("* from data where `council_reference` LIKE '#{record['council_reference']}'").empty? rescue true)
#	  ScraperWiki.save_sqlite(['council_reference'], record)
#      puts "Storing: #{record['council_reference']}"
#	else
#	  puts "Skipping already saved record " + record['council_reference']
#	end
end



