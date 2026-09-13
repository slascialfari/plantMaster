import Foundation
import SwiftData

enum PlantSeedData {
    struct SeedCategory {
        let name: String
        let colorHex: String
        let sortOrder: Int
    }

    struct SeedPlant {
        let index: Int
        let latinName: String
        let dutchName: String
        let categoryName: String
    }

    static let categories: [SeedCategory] = [
        SeedCategory(name: "Bomen", colorHex: "#2E7D5B", sortOrder: 0),
        SeedCategory(name: "Heesters", colorHex: "#B4622A", sortOrder: 1),
        SeedCategory(name: "Klimplanten", colorHex: "#7A4FB5", sortOrder: 2),
        SeedCategory(name: "Vaste planten", colorHex: "#C74E6E", sortOrder: 3),
        SeedCategory(name: "Grassen", colorHex: "#B8971F", sortOrder: 4),
    ]

    static let plants: [SeedPlant] = [
        // Bomen
        SeedPlant(index: 1, latinName: "Acer campestre", dutchName: "veldesdoorn, Spaanse aak", categoryName: "Bomen"),
        SeedPlant(index: 2, latinName: "Acer platanoides", dutchName: "Noorse esdoorn", categoryName: "Bomen"),
        SeedPlant(index: 3, latinName: "Acer pseudoplatanus", dutchName: "gewone esdoorn, bergesdoorn", categoryName: "Bomen"),
        SeedPlant(index: 4, latinName: "Aesculus hippocastanum", dutchName: "witte paardenkastanje", categoryName: "Bomen"),
        SeedPlant(index: 5, latinName: "Alnus glutinosa", dutchName: "zwarte els", categoryName: "Bomen"),
        SeedPlant(index: 6, latinName: "Alnus incana", dutchName: "witte els, grijze els", categoryName: "Bomen"),
        SeedPlant(index: 7, latinName: "Betula pendula", dutchName: "ruwe berk", categoryName: "Bomen"),
        SeedPlant(index: 8, latinName: "Betula pubescens", dutchName: "zachte berk", categoryName: "Bomen"),
        SeedPlant(index: 9, latinName: "Carpinus betulus", dutchName: "haagbeuk", categoryName: "Bomen"),
        SeedPlant(index: 10, latinName: "Castanea sativa", dutchName: "tamme kastanje", categoryName: "Bomen"),
        SeedPlant(index: 11, latinName: "Cercidiphyllum japonicum", dutchName: "katsuraboom, koekjesboom", categoryName: "Bomen"),
        SeedPlant(index: 12, latinName: "Fagus sylvatica", dutchName: "gewone beuk", categoryName: "Bomen"),
        SeedPlant(index: 13, latinName: "Fagus sylvatica ‘Atropunicea’", dutchName: "bruine beuk", categoryName: "Bomen"),
        SeedPlant(index: 14, latinName: "Fraxinus excelsior", dutchName: "gewone es", categoryName: "Bomen"),
        SeedPlant(index: 15, latinName: "Gleditsia triacanthos", dutchName: "valse christusdoorn", categoryName: "Bomen"),
        SeedPlant(index: 16, latinName: "Liquidambar styraciflua", dutchName: "amberboom", categoryName: "Bomen"),
        SeedPlant(index: 17, latinName: "Liriodendron tulipifera", dutchName: "tulpenboom", categoryName: "Bomen"),
        SeedPlant(index: 18, latinName: "Magnolia × soulangeana", dutchName: "gewone magnolia", categoryName: "Bomen"),
        SeedPlant(index: 19, latinName: "Platanus × hispanica", dutchName: "gewone plataan", categoryName: "Bomen"),
        SeedPlant(index: 20, latinName: "Populus alba", dutchName: "witte abeel", categoryName: "Bomen"),
        SeedPlant(index: 21, latinName: "Populus nigra ‘Italica’", dutchName: "Italiaanse populier", categoryName: "Bomen"),
        SeedPlant(index: 22, latinName: "Prunus avium", dutchName: "zoete kers, kriek", categoryName: "Bomen"),
        SeedPlant(index: 23, latinName: "Prunus cerasifera ‘Nigra’", dutchName: "kerspruim", categoryName: "Bomen"),
        SeedPlant(index: 24, latinName: "Prunus padus", dutchName: "vogelkers, troskers", categoryName: "Bomen"),
        SeedPlant(index: 25, latinName: "Prunus serrulata (cv)", dutchName: "Japanse kers", categoryName: "Bomen"),
        SeedPlant(index: 26, latinName: "Quercus palustris", dutchName: "moeraseik", categoryName: "Bomen"),
        SeedPlant(index: 27, latinName: "Quercus petraea", dutchName: "wintereik", categoryName: "Bomen"),
        SeedPlant(index: 28, latinName: "Quercus robur", dutchName: "zomereik", categoryName: "Bomen"),
        SeedPlant(index: 29, latinName: "Quercus rubra", dutchName: "Amerikaanse eik", categoryName: "Bomen"),
        SeedPlant(index: 30, latinName: "Robinia pseudoacacia", dutchName: "valse acacia, schijnacacia", categoryName: "Bomen"),
        SeedPlant(index: 31, latinName: "Salix alba", dutchName: "schietwilg", categoryName: "Bomen"),
        SeedPlant(index: 32, latinName: "Sorbus aucuparia", dutchName: "wilde lijsterbes", categoryName: "Bomen"),
        SeedPlant(index: 33, latinName: "Tilia × europaea", dutchName: "Hollandse linde", categoryName: "Bomen"),
        SeedPlant(index: 34, latinName: "Ulmus minor", dutchName: "veldiep", categoryName: "Bomen"),

        // Heesters
        SeedPlant(index: 35, latinName: "Acer palmatum", dutchName: "Japanse esdoorn", categoryName: "Heesters"),
        SeedPlant(index: 36, latinName: "Amelanchier lamarckii", dutchName: "Amerikaans krentenboompje", categoryName: "Heesters"),
        SeedPlant(index: 37, latinName: "Buddleja davidii (cv.)", dutchName: "vlinderstruik", categoryName: "Heesters"),
        SeedPlant(index: 38, latinName: "Cornus sanguinea", dutchName: "rode kornoelje", categoryName: "Heesters"),
        SeedPlant(index: 39, latinName: "Corylus avellana", dutchName: "gewone hazelaar", categoryName: "Heesters"),
        SeedPlant(index: 40, latinName: "Crataegus monogyna", dutchName: "gewone of éénstijlige meidoorn", categoryName: "Heesters"),
        SeedPlant(index: 41, latinName: "Euonymus europaeus", dutchName: "wilde kardinaalsmuts", categoryName: "Heesters"),
        SeedPlant(index: 42, latinName: "Frangula alnus", dutchName: "vuilboom", categoryName: "Heesters"),
        SeedPlant(index: 43, latinName: "Hydrangea paniculata", dutchName: "pluimhortensia", categoryName: "Heesters"),
        SeedPlant(index: 44, latinName: "Hypericum ‘Hidcote’", dutchName: "hertshooi", categoryName: "Heesters"),
        SeedPlant(index: 45, latinName: "Ilex aquifolium", dutchName: "scherpe hulst", categoryName: "Heesters"),
        SeedPlant(index: 46, latinName: "Ligustrum ovalifolium", dutchName: "haagliguster", categoryName: "Heesters"),
        SeedPlant(index: 47, latinName: "Ligustrum vulgare", dutchName: "wilde liguster", categoryName: "Heesters"),
        SeedPlant(index: 48, latinName: "Myrica gale", dutchName: "wilde gagel", categoryName: "Heesters"),
        SeedPlant(index: 49, latinName: "Potentilla fruticosa (cv)", dutchName: "struikganzerik", categoryName: "Heesters"),
        SeedPlant(index: 50, latinName: "Prunus serotina", dutchName: "Amerikaanse vogelkers", categoryName: "Heesters"),
        SeedPlant(index: 51, latinName: "Prunus spinosa", dutchName: "sleedoorn", categoryName: "Heesters"),
        SeedPlant(index: 52, latinName: "Ribes sanguineum", dutchName: "rode ribes", categoryName: "Heesters"),
        SeedPlant(index: 53, latinName: "Rosa canina", dutchName: "hondsroos", categoryName: "Heesters"),
        SeedPlant(index: 54, latinName: "Rosa rubiginosa", dutchName: "egelantier", categoryName: "Heesters"),
        SeedPlant(index: 55, latinName: "Rosa rugosa", dutchName: "Japanse bottelroos", categoryName: "Heesters"),
        SeedPlant(index: 56, latinName: "Rubus fruticosus", dutchName: "gewone braam", categoryName: "Heesters"),
        SeedPlant(index: 57, latinName: "Salix aurita", dutchName: "geoorde wilg", categoryName: "Heesters"),
        SeedPlant(index: 58, latinName: "Salix caprea", dutchName: "boswilg, waterwilg", categoryName: "Heesters"),
        SeedPlant(index: 59, latinName: "Salix cinerea", dutchName: "grauwe wilg", categoryName: "Heesters"),
        SeedPlant(index: 60, latinName: "Sambucus nigra", dutchName: "gewone vlier", categoryName: "Heesters"),
        SeedPlant(index: 61, latinName: "Spiraea japonica (cv)", dutchName: "spierstruik", categoryName: "Heesters"),
        SeedPlant(index: 62, latinName: "Symphoricarpos albus var. laevigatus", dutchName: "sneeuwbes", categoryName: "Heesters"),
        SeedPlant(index: 63, latinName: "Symphoricarpos × chenaultii", dutchName: "radijsboompje", categoryName: "Heesters"),
        SeedPlant(index: 64, latinName: "Syringa vulgaris", dutchName: "gewone sering", categoryName: "Heesters"),
        SeedPlant(index: 65, latinName: "Viburnum opulus", dutchName: "Gelderse roos", categoryName: "Heesters"),

        // Klimplanten
        SeedPlant(index: 66, latinName: "Clematis (cv)", dutchName: "clematis, bosrank", categoryName: "Klimplanten"),
        SeedPlant(index: 67, latinName: "Hedera helix", dutchName: "gewone klimop", categoryName: "Klimplanten"),
        SeedPlant(index: 68, latinName: "Hydrangea petiolaris", dutchName: "klimhortensia", categoryName: "Klimplanten"),
        SeedPlant(index: 69, latinName: "Lonicera periclymenum", dutchName: "wilde kamperfoelie", categoryName: "Klimplanten"),
        SeedPlant(index: 70, latinName: "Parthenocissus quinquefolia ‘Engelmannii’", dutchName: "wilde wingerd", categoryName: "Klimplanten"),
        SeedPlant(index: 71, latinName: "Vitis ‘Boskoop Glory’", dutchName: "druif", categoryName: "Klimplanten"),
        SeedPlant(index: 72, latinName: "Wisteria sinensis ‘Prolific’", dutchName: "blauwe regen", categoryName: "Klimplanten"),

        // Vaste planten
        SeedPlant(index: 73, latinName: "Aconitum carmichaelii ‘Arendsii’", dutchName: "monnikskap", categoryName: "Vaste planten"),
        SeedPlant(index: 74, latinName: "Anemone hupehensis ‘September Charm’", dutchName: "herfstanemoon, Japanse anemoon", categoryName: "Vaste planten"),
        SeedPlant(index: 75, latinName: "Anemone × hybrida ‘Honorine Jobert’", dutchName: "herfstanemoon, Japanse anemoon", categoryName: "Vaste planten"),
        SeedPlant(index: 76, latinName: "Aster ageratoides (cv)", dutchName: "herfstaster", categoryName: "Vaste planten"),
        SeedPlant(index: 77, latinName: "Aster divaricatus", dutchName: "herfstaster", categoryName: "Vaste planten"),
        SeedPlant(index: 78, latinName: "Aster × frikartii ‘Mönch’", dutchName: "herfstaster", categoryName: "Vaste planten"),
        SeedPlant(index: 79, latinName: "Geranium ROZANNE", dutchName: "ooievaarsbek", categoryName: "Vaste planten"),
        SeedPlant(index: 80, latinName: "Liriope muscari", dutchName: "leliegras", categoryName: "Vaste planten"),
        SeedPlant(index: 81, latinName: "Nepeta ‘Six Hills Giant’", dutchName: "kattenkruid", categoryName: "Vaste planten"),
        SeedPlant(index: 82, latinName: "Persicaria amplexicaulis", dutchName: "duizendknoop", categoryName: "Vaste planten"),
        SeedPlant(index: 83, latinName: "Rudbeckia fulgida ‘Goldsturm’", dutchName: "zonnehoed", categoryName: "Vaste planten"),
        SeedPlant(index: 84, latinName: "Sedum ‘Herbstfreude’", dutchName: "hemelsleutel", categoryName: "Vaste planten"),

        // Grassen
        SeedPlant(index: 85, latinName: "Miscanthus sinensis (cv)", dutchName: "zilvergras", categoryName: "Grassen"),
        SeedPlant(index: 86, latinName: "Panicum virgatum ‘Heavy Metal’", dutchName: "vingergras", categoryName: "Grassen"),
        SeedPlant(index: 87, latinName: "Pennisetum alopecuroides ‘Hameln’", dutchName: "lampenpoetsersgras", categoryName: "Grassen"),
    ]

    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        let existing = try? context.fetch(FetchDescriptor<Plant>())
        guard (existing?.isEmpty ?? true) else { return }

        var categoriesByName: [String: Category] = [:]
        for seedCategory in categories {
            let category = Category(name: seedCategory.name, colorHex: seedCategory.colorHex, sortOrder: seedCategory.sortOrder)
            context.insert(category)
            categoriesByName[seedCategory.name] = category
        }

        for seedPlant in plants {
            let plant = Plant(
                index: seedPlant.index,
                latinName: seedPlant.latinName,
                dutchName: seedPlant.dutchName,
                category: categoriesByName[seedPlant.categoryName]
            )
            context.insert(plant)
        }

        try? context.save()
    }
}
