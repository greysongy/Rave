//
//  ReportView.swift
//  Rave
//
//  Created by Bernie Cartin on 8/2/21.
//

import SwiftUI

struct ReportView: View {
    @EnvironmentObject var session: SessionManager
    
    var reasons = [
        ReportItem(title: "Innapropiate photos", checked: false),
        ReportItem(title: "Offensive comments", checked: false),
        ReportItem(title: "Rude or obscene profile", checked: false)
    ]
    
    @State var selectedReasons = [String]()
    
    @State var edges = UIApplication.shared.windows.first?.safeAreaInsets
    
    @Binding var showReport: Bool
    @Binding var showAlert: Bool
    
    var user: User?
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 18) {
                HStack {
                    Text("Report User")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    
                    Button(action: {
                        withAnimation{
                            showReport.toggle()
                            saveReport()
                        }
                    }, label: {
                        Text("Submit")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    })
                }
                .padding([.horizontal, .top])
                .padding(.bottom, 10)
                
                ForEach(reasons) { reason in
                    ReportCardView(reason: reason, selectedReasons: $selectedReasons)
                    
                }
            }
            .padding(.bottom, 30)
            .padding(.bottom, edges?.bottom)
            .padding(.top, 10)
            .background(Color.white.clipShape(CustomCorner(corners: [.topLeft, .topRight])))
            .offset(y: showReport ? -80 : UIScreen.main.bounds.height / 2)
        }
        .ignoresSafeArea()
        .background(
            Color.black.opacity(0.3).ignoresSafeArea()
                .opacity(showReport ? 1 : 0)
                .onTapGesture {
                    withAnimation{
                        showReport.toggle()
                    }
                }
        )
    }
    
    func saveReport() {
        if !selectedReasons.isEmpty {
            let report = Report(reportUser: user?.id, submitter: session.user.id, reasons: selectedReasons, date: Date())
//            ReportManager().saveReport(report: report)
            showAlert.toggle()
        }
    }
}

struct CustomCorner: Shape {
    
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 35, height: 35))
        
        return Path(path.cgPath)
    }
}

struct ReportView_Previews: PreviewProvider {
    @State static var showReport: Bool = false
    @State static var showAlert: Bool = false
    static var previews: some View {
        ReportView(showReport: $showReport, showAlert: $showAlert, user: User(id: "", name: "", email: ""))
            .environmentObject(SessionManager())
    }
}

struct ReportItem: Identifiable {
    
    var id = UUID().uuidString
    var title: String
    var checked: Bool
    
}

struct ReportCardView: View {
    @State var reason: ReportItem
    
    @Binding var selectedReasons: [String]
    
    var body: some View {
        HStack {
            Text(reason.title)
                .fontWeight(.semibold)
                .foregroundColor(Color.black.opacity(0.7))
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(reason.checked ? Color.blue : Color.gray, lineWidth: 1)
                    .frame(width: 25, height: 25)
                
                if reason.checked {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 25))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture {
            reason.checked.toggle()
            if reason.checked {
                selectedReasons.isEmpty ? selectedReasons = [reason.title] : selectedReasons.append(reason.title)
            }
            else {
                
            }
        }
    }
}
