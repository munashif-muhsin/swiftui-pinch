//
//  ContentView.swift
//  pinch
//
//  Created by Muhsin Munashif on 21/08/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    func resetImage() {
        withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                
                Image(pages[pageIndex - 1].imagename)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .scaleEffect(imageScale)
                    .opacity(isAnimating ? 1: 0)
                    .offset(imageOffset)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 2.5
                            }
                        } else {
                            resetImage()
                        }
                    })
                    .gesture(DragGesture()
                        .onChanged {  value in
                            withAnimation(.linear(duration: 1)) {
                                imageOffset = value.translation
                            }
                        }
                        .onEnded { value in
                            if imageScale <= 1 {
                                resetImage()
                            }
                        }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale < 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                    
                                }
                            }
                            .onEnded { _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    resetImage()
                                }
                            }
                    )
                
                
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                isAnimating = true
            })
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                , alignment: .top
            )
            .overlay(
                Group(
                    content: {
                        HStack {
                            Button(action: {
                                withAnimation(.spring()) {
                                    if imageScale > 1 {
                                        imageScale -= 1
                                        if imageScale <= 1 {
                                            resetImage()
                                        }
                                    }
                                }
                            } , label: {
                                ControlImageView(icon: "minus.magnifyingglass")
                            })
                            Button(action: {
                                resetImage()
                            } , label: {
                                ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                            })
                            Button(action: {
                                withAnimation(.spring()) {
                                    if imageScale < 5 {
                                        imageScale += 1
                                        
                                        if imageScale > 5 {
                                            imageScale = 5
                                        }
                                    }
                                }
                            } , label: {
                                ControlImageView(icon: "plus.magnifyingglass")
                            })
                        }
                        .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .opacity(isAnimating ? 1 : 0)
                    }
                )
                .padding(.bottom, 30)
                , alignment: .bottom
                
                
            ).overlay(
                HStack(spacing: 12) {
                    Image(systemName: isDrawerOpen ? "chevron.compact.right"  : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture( perform: {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        })
                    
                    ForEach(pages){ page in
                        Image(page.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture(perform: {
                                pageIndex = page.id
                                isAnimating = true
                            })
                    }
                    
                    Spacer()
                }
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12 )
                    .offset(x: isDrawerOpen ? 20: 215)
                , alignment: .topTrailing
            )
        }
        .navigationViewStyle(.stack)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
