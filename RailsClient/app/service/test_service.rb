class TestService
	def self.create
		#Package.destroy_all
		@packages = []
		50.times.each do |i|
			id = "WI00#{i+1}"
			part_id = Part.first.id
			quantity = "Q1000.0"
			check_in_time = "10.11.12"
			user = User.find_by_id("504435")
			PackageService.create({package:{id:id,part_id:part_id,check_in_time:check_in_time,quantity:quantity}},user)
		end
	end
end