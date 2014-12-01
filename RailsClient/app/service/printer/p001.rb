# print package list
module Printer
  class P001<Base
    HEAD=[:id, :whouse, :delivery_date, :user, :total_packages]
    BODY=[:package_id, :part_id, :quantity, :w_date, :receive_position]


    def generate_data
      f=LogisticsContainer.find_by_id(self.id)
      fp=ForkliftPresenter.new(f)

      head={id: fp.container_id,
            total_packages: fp.sum_packages,
            whouse: fp.destinationable_name,
            delivery_date: fp.created_at,
            user: fp.user_id}
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end
      packages=PackagePresenter.init_presenters(LogisticsContainerService.get_packages_with_detail(f, 'part_id,container_id'))
      packages.each do |p|
        body={package_id: p.container_id,
              part_id: p.part_id_display,
              quantity: p.quantity_display,
              w_date: p.fifo_time_display,
              receive_position: p.position_nr}
        bodies=[]
        BODY.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end
        self.data_set <<(heads+bodies)
      end
    end
  end
end
