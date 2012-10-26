#
# Copyright IBM  (2012)
# Author(s): Sean Dague      sdague@us.ibm.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
# ---------------------------------------

require 'yaml'
require File.dirname(__FILE__) + '/test_helper.rb'

class TestParsing < Test::Unit::TestCase

    def setup
    end

    def test_parsing_xml
        @testdirs = Array['test/samples']

        if ! FileTest.exists?(@testdirs[0]) or
                ! FileTest.directory?(@testdirs[0]) then
            puts "The ", @testdirs[0] , " directory does not exist!"
            exit!
        end

        @testdirs.each do |dir|
            Dir.entries(dir).each do |file|
                if file === '.' or file === '..' then
                    next
                end

                @testfile = "#{dir}/#{file}"

                # Test if the file is a dir, and add it to the traversal list if so
                if FileTest.directory?(@testfile) then
                    @testdirs << @testfile
                    next
                end

                # Test if the file is readable
                if ! FileTest.readable?(@testfile) then
                    puts "Could not read ", @testfile
                    next
                end

                # Process the file as a test file
                begin
                    @test = open(@testfile) {|f| YAML.load(f) }
                rescue
                    puts "Testfile not properly formatted for yaml: #{@testfile}"
                    next
                end

                # Make sure the variables we need exist
                if ! @test['output'] or ! @test['total'] or
                        ! @test['passed'] or ! @test['title'] or
                        ! @test['type'] then
                    puts "Testfile #{@testfile} is not properly formed."
                    next
                end

                # Make sure we support this connectathon test
                print "Testing #{@test['title']} ..."
                if @test['type'] === "basic" then
                    @gen = Cthon::Basic.new(@test['title'], @testfile)
                elsif @test['type'] === "locking" then
                    @gen = Cthon::Locking.new(@test['title'], @testfile)
                elsif @test['type'] === "general" then
                    @gen = Cthon::General.new(@test['title'], @testfile)
                elsif @test['type'] === "special" then
                    @gen = Cthon::Special.new(@test['title'], @testfile)
                else
                    print "\n"
                    next
                end

                # Compare the library's result of parsing to the expected result
                @gen.parsestr(@test['output'])
                @ts = @gen.testsuite


                assert_equal @ts.expected, @test['total'], "#{file} total is wrong #{@ts.expected} != #{@test['total']}"
                assert_equal @ts.passed, @test['passed'], "#{file} passed is wrong #{@ts.passed} != #{@test['passed']}"

                # this fills in the fake values to get you to expected
                xml = @ts.to_xml

                open("xml/#{file}.xml", 'w') do |f|
                    f.write(xml)
                end


                assert_equal @ts.total, @test['total'], "#{file} total is wrong #{@ts.total} != #{@test['total']}"
                assert_equal @ts.failed, @test['total'] - @test['passed'], "#{file} failed is wrong #{@ts.failed} != #{@test['total'] - @test['passed']}"

                # Test the xml conversion if it exists in test file

                # if @test['xml'] then
                #     print "\tTesting XML conversion now ..."
                #     @genxml = REXML::Document.new(@test['xml'])
                #     assert_equal @ts.to_xml.to_s.rstrip, @genxml.to_s.rstrip
                # end
                puts "\n"

            end
        end

    end

    def test_truth
        assert true
    end
end
