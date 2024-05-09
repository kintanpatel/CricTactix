//
//  ProfileSetting.swift
//  CricTactix
//
//  Created by kintan on 09/05/24.
//

import Foundation
import Photos
import SwiftUI

@available(iOS 14.0, macOS 10.16, *)
struct ProfileSetting: View {
    @AppStorage("name")  var name: String = ""
    @AppStorage("occupation") var animal: String = ""
    @AppStorage("email") var email: String = ""
    @AppStorage("autoRefresh") var refresh: Bool = false
    
    @State var showImagePicker: Bool = false
    @AppStorage("profileImageData") private var profileImageData: Data?
    @State private var permissionStatus: PHAuthorizationStatus = .notDetermined
       
    var body: some View {
            Form {
                Section(header: Text("About")) {
                    TextField("Name", text: $name)
                    TextField("Occupation", text: $animal)
                        .keyboardType(.default) // Set keyboard type to number pad for age
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress) // Set keyboard type to email address for email
                    HStack{
                        if(profileImageData == nil){
                            Image(uiImage: UIImage(named: "ic_user")!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }else{
                            Image(uiImage: UIImage(data: profileImageData!)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        Button {
                                // Action to open image picker
                                if (permissionStatus != .authorized){
                                    requestPermission()
                                    return
                                }
                            showImagePicker = true
                            
                            
                        } label: {
                            Text("Choose Profile Picture")
                        }
                    }
                }
                Section(header : Text("App Setting")){
                    Toggle("Auto Refresh Score", isOn: $refresh)
                    
                }
                
            }.sheet(isPresented: $showImagePicker) {
                ImagePickerManger(sourceType: .photoLibrary) { image in
                    
                    profileImageData = image.pngData()
                }
            }.onChange(of: permissionStatus, perform: { newValue in
                if (permissionStatus == .authorized){
                    showImagePicker = true
                }
            })
            .navigationTitle("Profile")
        }
    private func requestPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                self.permissionStatus = status
            }
        }
    }
    private func checkPermissionStatus() {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    self.permissionStatus = status
                }
            }
        }
}

@available(iOS 14.0, macOS 10.16, *)
#Preview {
    NavigationView{
        ProfileSetting()
    }
    
}
extension PHAuthorizationStatus {
    var description: String {
        switch self {
        case .notDetermined:
            return "Permission status not determined"
        case .restricted:
            return "Access to photo library is restricted"
        case .denied:
            return "Access to photo library denied"
        case .authorized:
            return "Access to photo library granted"
        case .limited:
            if #available(iOS 14.0, *) {
                return "Access to photo library is limited"
            } else {
                return ""
            }
        @unknown default:
            return "Unknown permission status"
        }
    }
}
