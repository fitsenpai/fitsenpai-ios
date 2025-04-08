import SwiftUI

struct SubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SubscriptionViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                dismissButton
                Spacer()
                ScrollViewReader { proxy in
                    pagesScrollView(proxy: proxy)
                }
                Spacer()
            }
            .padding(24)
            
            ZStack(alignment: .top) {
                // Top border with rounded corners
                HStack {
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.gray230, lineWidth: 1)
                        .frame(height: 40)
                        .mask(
                            VStack(spacing: 0) {
                                Rectangle()
                                    .frame(height: 20)
                                Rectangle()
                                    .frame(height: 20)
                                    .opacity(0)
                            }
                        )
                }
                .frame(height: 20)
                
                // Content
                VStack(alignment: .leading) {
                    subscriptionPlansGrid
                    bottomSection
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .padding(.top, -12)
            }
        }
        .sheet(isPresented: $viewModel.showSafariView) {
            if let url = viewModel.safariURL {
                SafariView(url: url)
            }
        }
    }
    
    private var dismissButton: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                    .padding(10)
                    .background(Circle().fill(Color.gray246))
            }
            Spacer()
        }
    }
    
    private func pagesScrollView(proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(viewModel.subscriptionPages.indices, id: \.self) { index in
                    SubscriptionPageView(page: viewModel.subscriptionPages[index])
                        .id(index)
                        .frame(width: UIScreen.main.bounds.width - 48)
                }
            }
        }
        .scrollDisabled(true)
        .onChange(of: viewModel.selectedPlan) { _, newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                proxy.scrollTo(newValue.pageIndex, anchor: .center)
                viewModel.currentPage = newValue.pageIndex
            }
        }
        .onAppear {
            proxy.scrollTo(1, anchor: .center)
        }
    }
    
    private var subscriptionPlansGrid: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.plans) { plan in
                SubscriptionPlanCard(
                    plan: plan,
                    isSelected: viewModel.selectedPlan == plan.type
                ) {
                    viewModel.selectedPlan = plan.type
                }
            }
        }
        .padding(.top, 20)
    }
    
    private var bottomSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image("icon_check_green")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                Text(viewModel.currentPageMessage)
                    .font(.body16)
            }
            
            FSButton(title: "Try it FREE", fontStyle: .bodyBold16, cornerRadius: 32) {
                viewModel.handleSubscription()
            }
            
            SubscriptionFooterView(
                onTermsTap: viewModel.handleTerms,
                onRestoreTap: viewModel.handleRestore,
                onPrivacyTap: viewModel.handlePrivacy
            )
        }
        .padding(.top, 20)
    }
}
