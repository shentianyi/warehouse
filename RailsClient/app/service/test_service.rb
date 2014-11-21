class TestService
	def self.create
		#Package.destroy_all
		@packages = []
		1.times.each do |i|
			id = "WI00#{i+1}"
			part_id = Part.first.id
			quantity = "1000.0"
			check_in_time = "10.11.12"
			user = User.find_by_id("504435")
			puts PackageService.create({package:{id:id,part_id:part_id,check_in_time:check_in_time,quantity:quantity}},user).to_json
		end
	end
end