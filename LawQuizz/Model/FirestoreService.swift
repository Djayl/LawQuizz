//
//  FirestoreService.swift
//  LawQuizz
//
//  Created by MacBook DS on 04/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

public enum FirestoreError: Error {
    case offline
    
}

public protocol FirestoreRequest {
    associatedtype FirestoreObject: DocumentSerializableProtocol
    typealias FirestoreCollectionResult<FirestoreObject: DocumentSerializableProtocol> = Result<[FirestoreObject], FirestoreError>
    typealias FirestoreDocumentResult<FirestoreObject: DocumentSerializableProtocol> = Result<FirestoreObject, FirestoreError>
    typealias FirestoreUpdateResult = Result<String, FirestoreError>
    
    func fetchCollection(endpoint: Endpoint, result: @escaping (FirestoreCollectionResult<FirestoreObject>) -> Void)
    func fetchDocument(endpoint: Endpoint, result: @escaping (FirestoreDocumentResult<FirestoreObject>) -> Void)
    func saveData(endpoint: Endpoint, identifier: String, data: [String: Any], result: @escaping (FirestoreUpdateResult) -> Void)
    func deleteDocumentData(endpoint: Endpoint, identifier: String, result: @escaping (FirestoreUpdateResult) -> Void)
    func updateData(endpoint: Endpoint, data: [String: Any], result: @escaping (FirestoreUpdateResult) -> Void)
}

final public class FirestoreService<FirestoreObject: DocumentSerializableProtocol>: FirestoreRequest {
    
    // MARK: - Properties
    
    private var dataBase = Firestore.firestore()
    private var collection: CollectionReference?
    private var document: DocumentReference?
    
    // MARK: - Init
    
    init() {
        let settings = dataBase.settings
        //        settings.areTimestampsInSnapshotsEnabled = true
        dataBase.settings = settings
    }
    
    // MARK: - Methods
    
    /// Fetch an array of Firestore Object from a collection in Firestore BDD and parse it into a Swift object
    ///
    /// - Parameter endpoint: The endpoint where to fetch collection in Firestore BDD
    /// - Parameter result: A result type to make action when it's success or failure
    public func fetchCollection(endpoint: Endpoint, result: @escaping (FirestoreCollectionResult<FirestoreObject>) -> Void) {
        collection = dataBase.collection(endpoint.path)
        collection?.getDocuments(completion: { (querySnapshot, error) in
            if error != nil {
                result(.failure(.offline))
            }
            
            guard let objectData = querySnapshot else {
                result(.failure(.offline))
                return
            }
            let object = objectData.documents.compactMap({FirestoreObject(dictionary: $0.data())})
            result(.success(object))
        })
    }
    
    public func fetchCollectionUnordered(endpoint: Endpoint, result: @escaping (FirestoreCollectionResult<FirestoreObject>) -> Void) {
        collection = dataBase.collection(endpoint.path)
        collection?.getDocuments(completion: { (querySnapshot, error) in
            if error != nil {
                result(.failure(.offline))
            }
            
            guard let objectData = querySnapshot else {
                result(.failure(.offline))
                return
            }
            let object = objectData.documents.compactMap({FirestoreObject(dictionary: $0.data())})
            result(.success(object))
        })
    }
    
    public func listenDocument(endpoint: Endpoint, result: @escaping (FirestoreDocumentResult<FirestoreObject>) -> Void) {
        // [START listen_document]
        document = dataBase.document(endpoint.path)
        document?.addSnapshotListener { (querySnapshot, error) in
            guard let document = querySnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data().map({FirestoreObject(dictionary: $0)}) as? FirestoreObject else {return }
            result(.success(data))
        }
    }
    
    public func listenCollection(endpoint: Endpoint, result: @escaping (FirestoreCollectionResult<FirestoreObject>) -> Void) {
        // [START listen_document]
        collection = dataBase.collection(endpoint.path)
        collection?.addSnapshotListener { (querySnapshot, error) in
            
            guard let objectData = querySnapshot else {
                result(.failure(.offline))
                return
            }
            let object = objectData.documents.compactMap({FirestoreObject(dictionary: $0.data())})
            result(.success(object))
            
        }
    }
    
    public func listenCollectionIfDiff(endpoint: Endpoint, result: @escaping (FirestoreCollectionResult<FirestoreObject>) -> Void) {
        collection = dataBase.collection(endpoint.path)
        collection?.addSnapshotListener { (querySnapshot, error) in
            
            guard let objectData = querySnapshot else {
                result(.failure(.offline))
                return
            }
            objectData.documentChanges.forEach {
                diff in
                
                if diff.type == .added {
                    let object = objectData.documents.compactMap({FirestoreObject(dictionary: $0.data())})
                    result(.success(object))
                }
            }
            
        }
    }
    
    /// Fetch a Firestore Object from a document in Firestore BDD and parse it into a Swift object
    ///
    /// - Parameter endpoint: The endpoint where to fetch document in Firestore BDD
    /// - Parameter result: A result type to make action when it's success or failure
    public func fetchDocument(endpoint: Endpoint, result: @escaping (FirestoreDocumentResult<FirestoreObject>) -> Void) {
        document = dataBase.document(endpoint.path)
        document?.getDocument(completion: { (documentSnapshot, error) in
            if error != nil {
                result(.failure(.offline))
            }
            
            guard let objectData = documentSnapshot, objectData.exists else {
                result(.failure(.offline))
                return
            }
            guard let object = objectData.data().map({FirestoreObject(dictionary: $0)}) as? FirestoreObject else { return }
            result(.success(object))
        })
    }
    
    /// Save data in a Firestore Document
    ///
    /// - Parameter endpoint: The endpoint where to save document in Firestore BDD
    /// - Parameter result: A result type to make action when it's success or failure
    public func saveData(endpoint: Endpoint, identifier: String, data: [String: Any], result: @escaping (FirestoreUpdateResult) -> Void) {
        collection = dataBase.collection(endpoint.path)
        collection?.document(identifier).setData(data, completion: { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                result(.failure(.offline))
            } else {
                result(.success("Document added with success"))
            }
        })
    }
    
    /// Delete document in a Firestore BDD
    ///
    /// - Parameter endpoint: The endpoint where to delete document in Firestore BDD
    /// - Parameter result: A result type to make action when it's success or failure
    public func deleteDocumentData(endpoint: Endpoint, identifier: String, result: @escaping (FirestoreUpdateResult) -> Void) {
        collection = dataBase.collection(endpoint.path)
        collection?.document(identifier).delete(completion: { error in
            if let error = error {
                print("Error deleting document: \(error)")
                result(.failure(.offline))
            } else {
                result(.success("Document deleted with success"))
            }
        })
    }
    
    /// Update document in a Firestore BDD
    ///
    /// - Parameter endpoint: The endpoint where to update document in Firestore BDD
    /// - Parameter result: A result type to make action when it's success or failure
    public func updateData(endpoint: Endpoint, data: [String: Any], result: @escaping (FirestoreUpdateResult) -> Void) {
        document = dataBase.document(endpoint.path)
        document?.updateData(data, completion: { error in
            if let error = error {
                print("Error updating document: \(error)")
                result(.failure(.offline))
            } else {
                result(.success("Document updated with success"))
            }
        })
    }
    
    public func updateDataIfExists(endpoint: Endpoint, data: [String: Any], result: @escaping (FirestoreUpdateResult) -> Void) {
           document = dataBase.document(endpoint.path)
            document?.setData(data, merge: true, completion: { error in
               if let error = error {
                   print("Error updating document: \(error)")
                   result(.failure(.offline))
               } else {
                   result(.success("Document updated with success"))
               }
           })
       }
    
    public func updateField(endpoint: Endpoint, data: [String: FieldValue], result: @escaping (FirestoreUpdateResult) -> Void) {
        document = dataBase.document(endpoint.path)
        
        document?.updateData(data, completion: { error in
            if let error = error {
                print("Error updating document: \(error)")
                result(.failure(.offline))
            } else {
                result(.success("Document updated with success"))
            }
        })
    }

 
    func checkUsername(field: String, endpoint: Endpoint, completion: @escaping (Bool) -> Void)  {
        collection = dataBase.collection(endpoint.path)
        collection?.whereField("userName", isEqualTo: field).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()["userName"] != nil {
                        completion(true)
                    }
                }
            }
        }
    }
    

}
