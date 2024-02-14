import SwiftUI
import Foundation
import Kingfisher

struct DetailContentSection: View {
    let imageUrl: String?
    let title: String
    let subTitle: String
    let description: String
    let trailingText: String
    var trailingImage: AnyView

    var body: some View {
        ScrollView(.vertical, content: {
            VStack(alignment: .leading, spacing: 0) {

                if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                    KFImage(url)
                        .resizable()
                        .frame(width: .none, height: 300)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 18))
                        .padding(.bottom, 20)

                } else {
                    Image(systemName: ("photo"))
                        .resizable()
                        .frame(maxHeight: 300)
                        .clipShape(.rect(cornerRadius: 18))
                        .padding(.bottom, 20)
                }

                HStack(spacing: 0) {
                    Text(title)
                        .customFont(Fonts.poppinsMedium, size: 22, color: Colors.blackColor)
                        .padding(.bottom, 2)
                    Spacer()

                    trailingImage

                    Text(trailingText)
                        .customFont(Fonts.poppinsMedium, size: 16, color: Colors.blackColor).padding(.trailing, 6)
                }

                Text(subTitle)
                    .customFont(Fonts.poppinsLight, size: 16, color: Colors.blackColor)
                    .padding(.bottom, 24)

                Text("Deskripsi")
                    .customFont(Fonts.poppinsMedium, size: 16, color: Colors.blackColor)
                    .padding(.bottom, 10)

                Text(description)
                    .customFont(Fonts.poppinsLight, size: 16, color: Colors.greyColor)
                    .lineSpacing(3)
            }.padding(.all, 24)
        })

    }
}
