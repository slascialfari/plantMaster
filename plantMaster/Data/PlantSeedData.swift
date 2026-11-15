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
        let periodID: String
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
        SeedCategory(name: "Wintergroenen", colorHex: "#2F6F8F", sortOrder: 5),
        SeedCategory(name: "Winterkenmerken", colorHex: "#6D5A4B", sortOrder: 6),
        SeedCategory(name: "Winterkleuren & wintergroene vaste planten", colorHex: "#B03A48", sortOrder: 7),
    ]

    static let plants: [SeedPlant] = trimester1 + trimester2

    /// Year 1 · Trimester 1.
    private static let trimester1: [SeedPlant] = [
        // Bomen
        SeedPlant(index: 1, periodID: StudyPeriod.y1t1.id, latinName: "Acer campestre", dutchName: "veldesdoorn, Spaanse aak", categoryName: "Bomen"),
        SeedPlant(index: 2, periodID: StudyPeriod.y1t1.id, latinName: "Acer platanoides", dutchName: "Noorse esdoorn", categoryName: "Bomen"),
        SeedPlant(index: 3, periodID: StudyPeriod.y1t1.id, latinName: "Acer pseudoplatanus", dutchName: "gewone esdoorn, bergesdoorn", categoryName: "Bomen"),
        SeedPlant(index: 4, periodID: StudyPeriod.y1t1.id, latinName: "Aesculus hippocastanum", dutchName: "witte paardenkastanje", categoryName: "Bomen"),
        SeedPlant(index: 5, periodID: StudyPeriod.y1t1.id, latinName: "Alnus glutinosa", dutchName: "zwarte els", categoryName: "Bomen"),
        SeedPlant(index: 6, periodID: StudyPeriod.y1t1.id, latinName: "Alnus incana", dutchName: "witte els, grijze els", categoryName: "Bomen"),
        SeedPlant(index: 7, periodID: StudyPeriod.y1t1.id, latinName: "Betula pendula", dutchName: "ruwe berk", categoryName: "Bomen"),
        SeedPlant(index: 8, periodID: StudyPeriod.y1t1.id, latinName: "Betula pubescens", dutchName: "zachte berk", categoryName: "Bomen"),
        SeedPlant(index: 9, periodID: StudyPeriod.y1t1.id, latinName: "Carpinus betulus", dutchName: "haagbeuk", categoryName: "Bomen"),
        SeedPlant(index: 10, periodID: StudyPeriod.y1t1.id, latinName: "Castanea sativa", dutchName: "tamme kastanje", categoryName: "Bomen"),
        SeedPlant(index: 11, periodID: StudyPeriod.y1t1.id, latinName: "Cercidiphyllum japonicum", dutchName: "katsuraboom, koekjesboom", categoryName: "Bomen"),
        SeedPlant(index: 12, periodID: StudyPeriod.y1t1.id, latinName: "Fagus sylvatica", dutchName: "gewone beuk", categoryName: "Bomen"),
        SeedPlant(index: 13, periodID: StudyPeriod.y1t1.id, latinName: "Fagus sylvatica 'Atropunicea'", dutchName: "bruine beuk", categoryName: "Bomen"),
        SeedPlant(index: 14, periodID: StudyPeriod.y1t1.id, latinName: "Fraxinus excelsior", dutchName: "gewone es", categoryName: "Bomen"),
        SeedPlant(index: 15, periodID: StudyPeriod.y1t1.id, latinName: "Gleditsia triacanthos", dutchName: "valse christusdoorn", categoryName: "Bomen"),
        SeedPlant(index: 16, periodID: StudyPeriod.y1t1.id, latinName: "Liquidambar styraciflua", dutchName: "amberboom", categoryName: "Bomen"),
        SeedPlant(index: 17, periodID: StudyPeriod.y1t1.id, latinName: "Liriodendron tulipifera", dutchName: "tulpenboom", categoryName: "Bomen"),
        SeedPlant(index: 18, periodID: StudyPeriod.y1t1.id, latinName: "Magnolia x soulangeana", dutchName: "gewone magnolia", categoryName: "Bomen"),
        SeedPlant(index: 19, periodID: StudyPeriod.y1t1.id, latinName: "Platanus x hispanica", dutchName: "gewone plataan", categoryName: "Bomen"),
        SeedPlant(index: 20, periodID: StudyPeriod.y1t1.id, latinName: "Populus alba", dutchName: "witte abeel", categoryName: "Bomen"),
        SeedPlant(index: 21, periodID: StudyPeriod.y1t1.id, latinName: "Populus nigra 'Italica'", dutchName: "Italiaanse populier", categoryName: "Bomen"),
        SeedPlant(index: 22, periodID: StudyPeriod.y1t1.id, latinName: "Prunus avium", dutchName: "zoete kers, kriek", categoryName: "Bomen"),
        SeedPlant(index: 23, periodID: StudyPeriod.y1t1.id, latinName: "Prunus cerasifera 'Nigra'", dutchName: "kerspruim", categoryName: "Bomen"),
        SeedPlant(index: 24, periodID: StudyPeriod.y1t1.id, latinName: "Prunus padus", dutchName: "vogelkers, troskers", categoryName: "Bomen"),
        SeedPlant(index: 25, periodID: StudyPeriod.y1t1.id, latinName: "Prunus serrulata", dutchName: "Japanse kers", categoryName: "Bomen"),
        SeedPlant(index: 26, periodID: StudyPeriod.y1t1.id, latinName: "Quercus palustris", dutchName: "moeraseik", categoryName: "Bomen"),
        SeedPlant(index: 27, periodID: StudyPeriod.y1t1.id, latinName: "Quercus petraea", dutchName: "wintereik", categoryName: "Bomen"),
        SeedPlant(index: 28, periodID: StudyPeriod.y1t1.id, latinName: "Quercus robur", dutchName: "zomereik", categoryName: "Bomen"),
        SeedPlant(index: 29, periodID: StudyPeriod.y1t1.id, latinName: "Quercus rubra", dutchName: "Amerikaanse eik", categoryName: "Bomen"),
        SeedPlant(index: 30, periodID: StudyPeriod.y1t1.id, latinName: "Robinia pseudoacacia", dutchName: "valse acacia, schijnacacia", categoryName: "Bomen"),
        SeedPlant(index: 31, periodID: StudyPeriod.y1t1.id, latinName: "Salix alba", dutchName: "schietwilg", categoryName: "Bomen"),
        SeedPlant(index: 32, periodID: StudyPeriod.y1t1.id, latinName: "Sorbus aucuparia", dutchName: "wilde lijsterbes", categoryName: "Bomen"),
        SeedPlant(index: 33, periodID: StudyPeriod.y1t1.id, latinName: "Tilia x europaea", dutchName: "Hollandse linde", categoryName: "Bomen"),
        SeedPlant(index: 34, periodID: StudyPeriod.y1t1.id, latinName: "Ulmus minor", dutchName: "veldiep", categoryName: "Bomen"),

        // Heesters
        SeedPlant(index: 35, periodID: StudyPeriod.y1t1.id, latinName: "Acer palmatum", dutchName: "Japanse esdoorn", categoryName: "Heesters"),
        SeedPlant(index: 36, periodID: StudyPeriod.y1t1.id, latinName: "Amelanchier lamarckii", dutchName: "Amerikaans krentenboompje", categoryName: "Heesters"),
        SeedPlant(index: 37, periodID: StudyPeriod.y1t1.id, latinName: "Buddleja davidii", dutchName: "vlinderstruik", categoryName: "Heesters"),
        SeedPlant(index: 38, periodID: StudyPeriod.y1t1.id, latinName: "Cornus sanguinea", dutchName: "rode kornoelje", categoryName: "Heesters"),
        SeedPlant(index: 39, periodID: StudyPeriod.y1t1.id, latinName: "Corylus avellana", dutchName: "gewone hazelaar", categoryName: "Heesters"),
        SeedPlant(index: 40, periodID: StudyPeriod.y1t1.id, latinName: "Crataegus monogyna", dutchName: "gewone of éénstijlige meidoorn", categoryName: "Heesters"),
        SeedPlant(index: 41, periodID: StudyPeriod.y1t1.id, latinName: "Euonymus europaeus", dutchName: "wilde kardinaalsmuts", categoryName: "Heesters"),
        SeedPlant(index: 42, periodID: StudyPeriod.y1t1.id, latinName: "Frangula alnus", dutchName: "vuilboom", categoryName: "Heesters"),
        SeedPlant(index: 43, periodID: StudyPeriod.y1t1.id, latinName: "Hydrangea paniculata", dutchName: "pluimhortensia", categoryName: "Heesters"),
        SeedPlant(index: 44, periodID: StudyPeriod.y1t1.id, latinName: "Hypericum 'Hidcote'", dutchName: "hertshooi", categoryName: "Heesters"),
        SeedPlant(index: 45, periodID: StudyPeriod.y1t1.id, latinName: "Ilex aquifolium", dutchName: "scherpe hulst", categoryName: "Heesters"),
        SeedPlant(index: 46, periodID: StudyPeriod.y1t1.id, latinName: "Ligustrum ovalifolium", dutchName: "haagliguster", categoryName: "Heesters"),
        SeedPlant(index: 47, periodID: StudyPeriod.y1t1.id, latinName: "Ligustrum vulgare", dutchName: "wilde liguster", categoryName: "Heesters"),
        SeedPlant(index: 48, periodID: StudyPeriod.y1t1.id, latinName: "Myrica gale", dutchName: "wilde gagel", categoryName: "Heesters"),
        SeedPlant(index: 49, periodID: StudyPeriod.y1t1.id, latinName: "Potentilla fruticosa", dutchName: "struikganzerik", categoryName: "Heesters"),
        SeedPlant(index: 50, periodID: StudyPeriod.y1t1.id, latinName: "Prunus serotina", dutchName: "Amerikaanse vogelkers", categoryName: "Heesters"),
        SeedPlant(index: 51, periodID: StudyPeriod.y1t1.id, latinName: "Prunus spinosa", dutchName: "sleedoorn", categoryName: "Heesters"),
        SeedPlant(index: 52, periodID: StudyPeriod.y1t1.id, latinName: "Ribes sanguineum", dutchName: "rode ribes", categoryName: "Heesters"),
        SeedPlant(index: 53, periodID: StudyPeriod.y1t1.id, latinName: "Rosa canina", dutchName: "hondsroos", categoryName: "Heesters"),
        SeedPlant(index: 54, periodID: StudyPeriod.y1t1.id, latinName: "Rosa rubiginosa", dutchName: "egelantier", categoryName: "Heesters"),
        SeedPlant(index: 55, periodID: StudyPeriod.y1t1.id, latinName: "Rosa rugosa", dutchName: "Japanse bottelroos", categoryName: "Heesters"),
        SeedPlant(index: 56, periodID: StudyPeriod.y1t1.id, latinName: "Rubus fruticosus", dutchName: "gewone braam", categoryName: "Heesters"),
        SeedPlant(index: 57, periodID: StudyPeriod.y1t1.id, latinName: "Salix aurita", dutchName: "geoorde wilg", categoryName: "Heesters"),
        SeedPlant(index: 58, periodID: StudyPeriod.y1t1.id, latinName: "Salix caprea", dutchName: "boswilg, waterwilg", categoryName: "Heesters"),
        SeedPlant(index: 59, periodID: StudyPeriod.y1t1.id, latinName: "Salix cinerea", dutchName: "grauwe wilg", categoryName: "Heesters"),
        SeedPlant(index: 60, periodID: StudyPeriod.y1t1.id, latinName: "Sambucus nigra", dutchName: "gewone vlier", categoryName: "Heesters"),
        SeedPlant(index: 61, periodID: StudyPeriod.y1t1.id, latinName: "Spiraea japonica", dutchName: "spierstruik", categoryName: "Heesters"),
        SeedPlant(index: 62, periodID: StudyPeriod.y1t1.id, latinName: "Symphoricarpos albus var. laevigatus", dutchName: "sneeuwbes", categoryName: "Heesters"),
        SeedPlant(index: 63, periodID: StudyPeriod.y1t1.id, latinName: "Symphoricarpos x chenaultii", dutchName: "radijsboompje", categoryName: "Heesters"),
        SeedPlant(index: 64, periodID: StudyPeriod.y1t1.id, latinName: "Syringa vulgaris", dutchName: "gewone sering", categoryName: "Heesters"),
        SeedPlant(index: 65, periodID: StudyPeriod.y1t1.id, latinName: "Viburnum opulus", dutchName: "Gelderse roos", categoryName: "Heesters"),

        // Klimplanten
        SeedPlant(index: 66, periodID: StudyPeriod.y1t1.id, latinName: "Clematis", dutchName: "clematis, bosrank", categoryName: "Klimplanten"),
        SeedPlant(index: 67, periodID: StudyPeriod.y1t1.id, latinName: "Hedera helix", dutchName: "gewone klimop", categoryName: "Klimplanten"),
        SeedPlant(index: 68, periodID: StudyPeriod.y1t1.id, latinName: "Hydrangea petiolaris", dutchName: "klimhortensia", categoryName: "Klimplanten"),
        SeedPlant(index: 69, periodID: StudyPeriod.y1t1.id, latinName: "Lonicera periclymenum", dutchName: "wilde kamperfoelie", categoryName: "Klimplanten"),
        SeedPlant(index: 70, periodID: StudyPeriod.y1t1.id, latinName: "Parthenocissus quinquefolia 'Engelmannii'", dutchName: "wilde wingerd", categoryName: "Klimplanten"),
        SeedPlant(index: 71, periodID: StudyPeriod.y1t1.id, latinName: "Vitis 'Boskoop Glory'", dutchName: "druif", categoryName: "Klimplanten"),
        SeedPlant(index: 72, periodID: StudyPeriod.y1t1.id, latinName: "Wisteria sinensis 'Prolific'", dutchName: "blauwe regen", categoryName: "Klimplanten"),

        // Vaste planten
        SeedPlant(index: 73, periodID: StudyPeriod.y1t1.id, latinName: "Aconitum carmichaelii 'Arendsii'", dutchName: "monnikskap", categoryName: "Vaste planten"),
        SeedPlant(index: 74, periodID: StudyPeriod.y1t1.id, latinName: "Anemone hupehensis 'September Charm'", dutchName: "herfstanemoon, Japanse anemoon", categoryName: "Vaste planten"),
        SeedPlant(index: 75, periodID: StudyPeriod.y1t1.id, latinName: "Anemone x hybrida 'Honorine Jobert'", dutchName: "herfstanemoon, Japanse anemoon", categoryName: "Vaste planten"),
        SeedPlant(index: 76, periodID: StudyPeriod.y1t1.id, latinName: "Aster ageratoides", dutchName: "herfstaster", categoryName: "Vaste planten"),
        SeedPlant(index: 77, periodID: StudyPeriod.y1t1.id, latinName: "Aster divaricatus", dutchName: "herfstaster", categoryName: "Vaste planten"),
        SeedPlant(index: 78, periodID: StudyPeriod.y1t1.id, latinName: "Aster x frikartii 'Mönch'", dutchName: "herfstaster", categoryName: "Vaste planten"),
        SeedPlant(index: 79, periodID: StudyPeriod.y1t1.id, latinName: "Geranium ROZANNE", dutchName: "ooievaarsbek", categoryName: "Vaste planten"),
        SeedPlant(index: 80, periodID: StudyPeriod.y1t1.id, latinName: "Liriope muscari", dutchName: "leliegras", categoryName: "Vaste planten"),
        SeedPlant(index: 81, periodID: StudyPeriod.y1t1.id, latinName: "Nepeta 'Six Hills Giant'", dutchName: "kattenkruid", categoryName: "Vaste planten"),
        SeedPlant(index: 82, periodID: StudyPeriod.y1t1.id, latinName: "Persicaria amplexicaulis", dutchName: "duizendknoop", categoryName: "Vaste planten"),
        SeedPlant(index: 83, periodID: StudyPeriod.y1t1.id, latinName: "Rudbeckia fulgida 'Goldsturm'", dutchName: "zonnehoed", categoryName: "Vaste planten"),
        SeedPlant(index: 84, periodID: StudyPeriod.y1t1.id, latinName: "Sedum 'Herbstfreude'", dutchName: "hemelsleutel", categoryName: "Vaste planten"),

        // Grassen
        SeedPlant(index: 85, periodID: StudyPeriod.y1t1.id, latinName: "Miscanthus sinensis", dutchName: "zilvergras", categoryName: "Grassen"),
        SeedPlant(index: 86, periodID: StudyPeriod.y1t1.id, latinName: "Panicum virgatum 'Heavy Metal'", dutchName: "vingergras", categoryName: "Grassen"),
        SeedPlant(index: 87, periodID: StudyPeriod.y1t1.id, latinName: "Pennisetum alopecuroides 'Hameln'", dutchName: "lampepoetsersgras", categoryName: "Grassen"),
    ]

    /// Year 1 · Trimester 2 (wintersortiment). Plants the school lists without a Dutch name
    /// ("-") have an empty one.
    private static let trimester2: [SeedPlant] = [
        // Wintergroenen
        SeedPlant(index: 1, periodID: StudyPeriod.y1t2.id, latinName: "Abies nordmanniana", dutchName: "nordmann-zilverspar", categoryName: "Wintergroenen"),
        SeedPlant(index: 2, periodID: StudyPeriod.y1t2.id, latinName: "Buxus sempervirens", dutchName: "palmboompje", categoryName: "Wintergroenen"),
        SeedPlant(index: 3, periodID: StudyPeriod.y1t2.id, latinName: "Chamaecyparis lawsoniana 'Columnaris'", dutchName: "Californische cipres", categoryName: "Wintergroenen"),
        SeedPlant(index: 4, periodID: StudyPeriod.y1t2.id, latinName: "Cotoneaster x suecicus 'Coral Beauty'", dutchName: "rotsmispel, dwergmispel", categoryName: "Wintergroenen"),
        SeedPlant(index: 5, periodID: StudyPeriod.y1t2.id, latinName: "x Cupressocyparis leylandii", dutchName: "bastaardcipres", categoryName: "Wintergroenen"),
        SeedPlant(index: 6, periodID: StudyPeriod.y1t2.id, latinName: "Gaultheria shallon", dutchName: "bergthee", categoryName: "Wintergroenen"),
        SeedPlant(index: 7, periodID: StudyPeriod.y1t2.id, latinName: "Ilex crenata", dutchName: "Japanse hulst", categoryName: "Wintergroenen"),
        SeedPlant(index: 8, periodID: StudyPeriod.y1t2.id, latinName: "Juniperus communis", dutchName: "jeneverbes", categoryName: "Wintergroenen"),
        SeedPlant(index: 9, periodID: StudyPeriod.y1t2.id, latinName: "Ligustrum ovalifolium", dutchName: "haagliguster", categoryName: "Wintergroenen"),
        SeedPlant(index: 10, periodID: StudyPeriod.y1t2.id, latinName: "Lonicera nitida 'Elegant'", dutchName: "struikkamperfoelie", categoryName: "Wintergroenen"),
        SeedPlant(index: 11, periodID: StudyPeriod.y1t2.id, latinName: "Microbiota decussata", dutchName: "", categoryName: "Wintergroenen"),
        SeedPlant(index: 12, periodID: StudyPeriod.y1t2.id, latinName: "Pachysandra terminalis", dutchName: "", categoryName: "Wintergroenen"),
        SeedPlant(index: 13, periodID: StudyPeriod.y1t2.id, latinName: "Picea abies", dutchName: "fijnspar", categoryName: "Wintergroenen"),
        SeedPlant(index: 14, periodID: StudyPeriod.y1t2.id, latinName: "Pinus sylvestris", dutchName: "grove den", categoryName: "Wintergroenen"),
        SeedPlant(index: 15, periodID: StudyPeriod.y1t2.id, latinName: "Prunus laurocerasus", dutchName: "laurierkers", categoryName: "Wintergroenen"),
        SeedPlant(index: 16, periodID: StudyPeriod.y1t2.id, latinName: "Pseudotsuga menziesii", dutchName: "douglasspar", categoryName: "Wintergroenen"),
        SeedPlant(index: 17, periodID: StudyPeriod.y1t2.id, latinName: "Taxus baccata", dutchName: "venijnboom", categoryName: "Wintergroenen"),
        SeedPlant(index: 18, periodID: StudyPeriod.y1t2.id, latinName: "Thuja occidentalis 'Brabant'", dutchName: "westerse levensboom", categoryName: "Wintergroenen"),
        SeedPlant(index: 19, periodID: StudyPeriod.y1t2.id, latinName: "Thuja plicata", dutchName: "reuzenlevensboom", categoryName: "Wintergroenen"),
        SeedPlant(index: 20, periodID: StudyPeriod.y1t2.id, latinName: "Tsuga canadensis", dutchName: "Oostelijke hemlockspar", categoryName: "Wintergroenen"),

        // Winterkenmerken
        SeedPlant(index: 21, periodID: StudyPeriod.y1t2.id, latinName: "Acer campestre", dutchName: "veldesdoorn, Spaanse aak", categoryName: "Winterkenmerken"),
        SeedPlant(index: 22, periodID: StudyPeriod.y1t2.id, latinName: "Acer platanoides", dutchName: "Noorse esdoorn", categoryName: "Winterkenmerken"),
        SeedPlant(index: 23, periodID: StudyPeriod.y1t2.id, latinName: "Acer pseudoplatanus", dutchName: "gewone esdoorn", categoryName: "Winterkenmerken"),
        SeedPlant(index: 24, periodID: StudyPeriod.y1t2.id, latinName: "Alnus glutinosa", dutchName: "zwarte els", categoryName: "Winterkenmerken"),
        SeedPlant(index: 25, periodID: StudyPeriod.y1t2.id, latinName: "Carpinus betulus", dutchName: "haagbeuk", categoryName: "Winterkenmerken"),
        SeedPlant(index: 26, periodID: StudyPeriod.y1t2.id, latinName: "Cornus sanguinea", dutchName: "rode kornoelje", categoryName: "Winterkenmerken"),
        SeedPlant(index: 27, periodID: StudyPeriod.y1t2.id, latinName: "Corylus avellana", dutchName: "gewone hazelaar", categoryName: "Winterkenmerken"),
        SeedPlant(index: 28, periodID: StudyPeriod.y1t2.id, latinName: "Crataegus monogyna", dutchName: "gewone of éénstijlige meidoorn", categoryName: "Winterkenmerken"),
        SeedPlant(index: 29, periodID: StudyPeriod.y1t2.id, latinName: "Fagus sylvatica", dutchName: "gewone beuk", categoryName: "Winterkenmerken"),
        SeedPlant(index: 30, periodID: StudyPeriod.y1t2.id, latinName: "Fraxinus excelsior", dutchName: "gewone es", categoryName: "Winterkenmerken"),
        SeedPlant(index: 31, periodID: StudyPeriod.y1t2.id, latinName: "Prunus avium", dutchName: "zoete kers", categoryName: "Winterkenmerken"),
        SeedPlant(index: 32, periodID: StudyPeriod.y1t2.id, latinName: "Prunus serotina", dutchName: "Amerikaanse vogelkers", categoryName: "Winterkenmerken"),
        SeedPlant(index: 33, periodID: StudyPeriod.y1t2.id, latinName: "Prunus spinosa", dutchName: "sleedoorn", categoryName: "Winterkenmerken"),
        SeedPlant(index: 34, periodID: StudyPeriod.y1t2.id, latinName: "Quercus robur", dutchName: "zomereik", categoryName: "Winterkenmerken"),
        SeedPlant(index: 35, periodID: StudyPeriod.y1t2.id, latinName: "Salix alba", dutchName: "schietwilg", categoryName: "Winterkenmerken"),
        SeedPlant(index: 36, periodID: StudyPeriod.y1t2.id, latinName: "Salix caprea", dutchName: "boswilg, waterwilg", categoryName: "Winterkenmerken"),
        SeedPlant(index: 37, periodID: StudyPeriod.y1t2.id, latinName: "Sambucus nigra", dutchName: "gewone vlier", categoryName: "Winterkenmerken"),
        SeedPlant(index: 38, periodID: StudyPeriod.y1t2.id, latinName: "Sorbus aucuparia", dutchName: "wilde lijsterbes", categoryName: "Winterkenmerken"),
        SeedPlant(index: 39, periodID: StudyPeriod.y1t2.id, latinName: "Tilia x europaea", dutchName: "Hollandse linde", categoryName: "Winterkenmerken"),
        SeedPlant(index: 40, periodID: StudyPeriod.y1t2.id, latinName: "Viburnum opulus", dutchName: "gelderse roos", categoryName: "Winterkenmerken"),

        // Winterkleuren & wintergroene vaste planten
        SeedPlant(index: 41, periodID: StudyPeriod.y1t2.id, latinName: "Bergenia cordifolia 'Purpurea'", dutchName: "schoenlappersplant", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 42, periodID: StudyPeriod.y1t2.id, latinName: "Carex morrowii", dutchName: "zegge", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 43, periodID: StudyPeriod.y1t2.id, latinName: "Cornus alba 'Sibirica'", dutchName: "witte kornoelje", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 44, periodID: StudyPeriod.y1t2.id, latinName: "Cornus mas", dutchName: "gele kornoelje", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 45, periodID: StudyPeriod.y1t2.id, latinName: "Deschampsia cespitosa", dutchName: "ruwe smele", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 46, periodID: StudyPeriod.y1t2.id, latinName: "Epimedium x perralchicum 'Frohnleiten'", dutchName: "elfenbloem", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 47, periodID: StudyPeriod.y1t2.id, latinName: "Fargesia murieliae", dutchName: "bamboe", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 48, periodID: StudyPeriod.y1t2.id, latinName: "Geranium macrorrhizum", dutchName: "ooievaarsbek", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 49, periodID: StudyPeriod.y1t2.id, latinName: "Hamamelis mollis", dutchName: "toverhazelaar", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 50, periodID: StudyPeriod.y1t2.id, latinName: "Heuchera micrantha 'Palace Purple'", dutchName: "purperklokje", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 51, periodID: StudyPeriod.y1t2.id, latinName: "Lamiastrum galeobdolon 'Florentinum'", dutchName: "bonte gele dovenetel", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 52, periodID: StudyPeriod.y1t2.id, latinName: "Lavandula angustifolia", dutchName: "lavendel", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 53, periodID: StudyPeriod.y1t2.id, latinName: "Lonicera x purpusii 'Winter Beauty'", dutchName: "struikkamperfoelie", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 54, periodID: StudyPeriod.y1t2.id, latinName: "Luzula sylvatica", dutchName: "grote veldbies", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 55, periodID: StudyPeriod.y1t2.id, latinName: "Molinia caerulea", dutchName: "pijpenstrootje", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 56, periodID: StudyPeriod.y1t2.id, latinName: "Phlomis russeliana", dutchName: "brandkruid", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 57, periodID: StudyPeriod.y1t2.id, latinName: "Prunus x subhirtella 'Autumnalis'", dutchName: "najaarskers", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 58, periodID: StudyPeriod.y1t2.id, latinName: "Sesleria autumnalis", dutchName: "blauwgras", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 59, periodID: StudyPeriod.y1t2.id, latinName: "Viburnum tinus", dutchName: "sneeuwbal", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 60, periodID: StudyPeriod.y1t2.id, latinName: "Viburnum x bodnantense 'Dawn'", dutchName: "sneeuwbal", categoryName: "Winterkleuren & wintergroene vaste planten"),
        SeedPlant(index: 61, periodID: StudyPeriod.y1t2.id, latinName: "Waldsteinia ternata", dutchName: "", categoryName: "Winterkleuren & wintergroene vaste planten"),
    ]

    /// Brings the store in line with the seed lists on every launch: adds any category or
    /// plant that is missing (such as a newly added period's list on a device that already
    /// has the earlier ones) and restores seeded fields that drifted. Photos, notes, pins
    /// and the Known/Handpicked marks are never touched.
    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        var didChange = false

        let storedCategories = (try? context.fetch(FetchDescriptor<Category>())) ?? []
        var categoriesByName = Dictionary(storedCategories.map { ($0.name, $0) }, uniquingKeysWith: { first, _ in first })
        for seedCategory in categories {
            if let category = categoriesByName[seedCategory.name] {
                if category.colorHex != seedCategory.colorHex {
                    category.colorHex = seedCategory.colorHex
                    didChange = true
                }
                if category.sortOrder != seedCategory.sortOrder {
                    category.sortOrder = seedCategory.sortOrder
                    didChange = true
                }
            } else {
                let category = Category(name: seedCategory.name, colorHex: seedCategory.colorHex, sortOrder: seedCategory.sortOrder)
                context.insert(category)
                categoriesByName[seedCategory.name] = category
                didChange = true
            }
        }

        let existing = (try? context.fetch(FetchDescriptor<Plant>())) ?? []
        let existingByKey = Dictionary(existing.map { (key(periodID: $0.periodID, index: $0.index), $0) }, uniquingKeysWith: { first, _ in first })

        for seed in plants {
            if let plant = existingByKey[key(periodID: seed.periodID, index: seed.index)] {
                if repair(plant, from: seed, categoriesByName: categoriesByName) {
                    didChange = true
                }
            } else {
                context.insert(Plant(
                    index: seed.index,
                    periodID: seed.periodID,
                    latinName: seed.latinName,
                    dutchName: seed.dutchName,
                    category: categoriesByName[seed.categoryName]
                ))
                didChange = true
            }
        }

        if didChange {
            try? context.save()
        }
    }

    /// A plant is identified by its period and its number on that period's list.
    private static func key(periodID: String, index: Int) -> String {
        "\(periodID)#\(index)"
    }

    /// Names and categories come from the seed list and are not user-editable, so any
    /// stored value that drifted from the seed (for example a name cleared by accident
    /// in an earlier version of the editor) is restored. Returns whether anything changed.
    private static func repair(_ plant: Plant, from seed: SeedPlant, categoriesByName: [String: Category]) -> Bool {
        var didChange = false
        if plant.latinName != seed.latinName {
            plant.latinName = seed.latinName
            didChange = true
        }
        if plant.dutchName != seed.dutchName {
            plant.dutchName = seed.dutchName
            didChange = true
        }
        if plant.category == nil, let category = categoriesByName[seed.categoryName] {
            plant.category = category
            didChange = true
        }
        return didChange
    }
}
