
pub const IApp = struct {
    fn pre_init(self: IApp) void {_ = self;}
    fn post_init(self: IApp) void {_ = self;}
    fn draw(self: IApp) void {_ = self;}
    fn update(self: IApp, dt: f64) void {_ = self; _ = dt;}
};