Whouse.transaction do
  Location.all.each do |l|
    if l.default_whouse.blank?
      unless w=Whouse.find_by_nr(l.nr)
        w=Whouse.create(nr: l.nr, name: l.nr, location_id: l.id)
        w.positions.create(nr: w.nr, is_default: true)
        w.save
      end
      l.default_whouse=w
      l.save
    end
  end
end