//
//  ParkingStatusView.swift
//  hangangpark
//

import SwiftUI

struct ParkingStatusView: View {
    let session: UserSession
    let onLogout: () -> Void

    @StateObject private var viewModel = ParkingStatusViewModel()
    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.97, blue: 0.99)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    header
                    currentSummary
                    currentParkingSection
                    actionButtons

                    if !viewModel.message.isEmpty {
                        Text(viewModel.message)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("로그아웃", action: onLogout)
                    .foregroundStyle(Color(red: 0.16, green: 0.38, blue: 0.83))
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await viewModel.loadParkingLots() }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                .disabled(viewModel.isLoading)
            }
        }
        .task {
            await viewModel.loadParkingLots()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("뚝섬 한강공원")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)

                    Text("현재 주차가능대수")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.88))
                }

                Spacer()

                Image(systemName: "car.2.fill")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 62, height: 62)
                    .background(Color.white.opacity(0.16))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Text("로그인 계정: \(session.email)")
                .font(.footnote.weight(.medium))
                .foregroundStyle(.white.opacity(0.9))
                .lineLimit(1)
                .truncationMode(.middle)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.11, green: 0.34, blue: 0.72))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var currentSummary: some View {
        HStack(spacing: 14) {
            SummaryCard(title: "현재 잔여", value: "\(viewModel.totalAvailable)대", systemImage: "parkingsign.circle.fill")
            SummaryCard(title: "조회 구역", value: "4곳", systemImage: "mappin.and.ellipse")
        }
    }

    private var currentParkingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("현재 잔여 대수")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Color(red: 0.12, green: 0.16, blue: 0.22))
                    Text("한강공원 주차 페이지의 주차가능대수를 가져옵니다.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(viewModel.isLoading ? "업데이트 중" : "실시간")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color(red: 0.06, green: 0.52, blue: 0.48))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.89, green: 0.97, blue: 0.96))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            ForEach(viewModel.displayParkingLots) { lot in
                ParkingLotRow(lot: lot)
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            NavigationLink {
                ParkingPredictionView(viewModel: viewModel)
            } label: {
                MainActionButtonLabel(
                    title: "잔여 대수 예측하기",
                    subtitle: "1~8시간 뒤 주차장별 잔여 대수를 확인하세요.",
                    systemImage: "clock.fill",
                    color: Color(red: 0.16, green: 0.38, blue: 0.83)
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                ConvenienceMapView()
            } label: {
                MainActionButtonLabel(
                    title: "주변 편의점 찾아보기",
                    subtitle: "지도 화면에서 가까운 편의점을 확인하세요.",
                    systemImage: "map.fill",
                    color: Color(red: 0.06, green: 0.52, blue: 0.48)
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                FacilityRecommendationView()
            } label: {
                MainActionButtonLabel(
                    title: "연관 추천 정보",
                    subtitle: "뚝섬 한강공원 연관 추천 정보를 확인하세요.",
                    systemImage: "calendar.badge.plus",
                    color: Color(red: 0.35, green: 0.42, blue: 0.56)
                )
            }
            .buttonStyle(.plain)
        }
    }
}

private struct SummaryCard: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.headline)
                .foregroundStyle(Color(red: 0.16, green: 0.38, blue: 0.83))
                .frame(width: 38, height: 38)
                .background(Color(red: 0.92, green: 0.95, blue: 1.0))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Color(red: 0.12, green: 0.16, blue: 0.22))
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

private struct MainActionButtonLabel: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color(red: 0.12, green: 0.16, blue: 0.22))
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.bold))
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

#Preview {
    NavigationStack {
        ParkingStatusView(
            session: UserSession(userid: 1, useremail: "user@example.com", userage: 24, usersex: 1),
            onLogout: {}
        )
    }
}
