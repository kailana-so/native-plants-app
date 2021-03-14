require 'pg'

require_relative 'lib'


name1 = %w|shrub brush bottle bell fern|
name2 = %w|blue pink black yellow|

latinName = ["Gossypium sturtianum", "Helleborus niger", "Boronia serrulata", "Pelargonium X asperum"]

description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

family = %w|Proteaceae Myrtaceae Mimosaceae Rutaceae Asteraceae|

color = %w|blue pink black red yellow green purple|

number_of_petals = [2, 5, 8, 4, 1, 9, 6]

leaf_shape = %w|linear ovate reniform coradat elliptical oblong winged tube bell|

leaf_margin = %w|dentate serrate crenate sinuate|

location = %w|Woonona Dapto Killea Thirroul|

plant_status = %w|rare disappearing abundant|

image_url = ["https://i.pinimg.com/originals/f6/a9/ae/f6a9aec250cabbab3219661f430822f4.jpg", "https://www.australianseed.com/persistent/catalogue_images/products/telopea-speciosissima-1.jpg", "https://www.northsydney.nsw.gov.au/files/2bfe3c36-5fb9-48d1-a50d-a12e00991508/Eucalyptus_haemastoma.jpg", "https://www.rbgsyd.nsw.gov.au/getmedia/5ba519d9-200f-4d63-8099-7874d5771b94/Pimelea-spicata.jpg", "https://i.pinimg.com/originals/7b/ca/88/7bca888909d6abbd66de00df6c58fbef.jpg", "https://www.gardensonline.com.au/Uploads/Plant/3260/CorymbiaCalophylla4.jpg"]

# user_id = run_sql("SELECT * FROM users;").first[:id]


6.times do

    run_sql("INSERT INTO plants (name, latin_name, description, family, color, number_of_petals, leaf_shape, leaf_margin, location, plant_status, image_url) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)", 
    [
        "#{name2.sample} #{name1.sample}",
        "#{latinName.sample}",
        "#{description}",
        "#{family.sample}",
        "#{color.sample}",
        "#{number_of_petals.sample}",
        "#{leaf_shape.sample}",
        "#{leaf_margin.sample}",
        "#{location.sample}",
        "#{plant_status.sample}",
        "#{image_url.sample}",
        # user_id
    ]
)
end
