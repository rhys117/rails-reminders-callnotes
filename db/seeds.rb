User.create!(name:  "Example User",
             correspondence: "example@example.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

y = 0
5.times do |n|
  n = 0
  5.times do
    user = User.find(1)
    date = Date.today + y
    reference = (00000 + n).to_s
    vocus = n == 3 ? true : nil
    vocus_ticket = n == 3 ? "1111" : nil
    nbn_search = n == 2 ? "INC111" : nil
    service_type = "FTTN"
    priority = n + 1
    notes = "Sample Notes"
    user.reminders.create!(date: date, reference: reference, vocus: vocus,
                           vocus_ticket: vocus_ticket, nbn_search: nbn_search,
                           service_type: service_type, priority: priority,
                           notes: notes)
    n += 1
  end
  y += 1
end