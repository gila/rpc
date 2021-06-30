pub mod mayastor {
    impl From<()> for Null {
        fn from(_: ()) -> Self {
            Self {}
        }
    }
    tonic::include_proto!("mayastor");
}
