library(ggplot2)


# stand cv stats:
s_cv <- read.csv("in_data.csv")

# put na to -3.5 so they plot in the bottom row
s_cv[is.na(s_cv)] <- -3.5

g_cv <- ggplot(s_cv, aes(x=s_cv[6], y=s_cv[3]), environment = environment()) + 
geom_rect(xmin = -1, xmax = 1, ymin = -1, ymax = 1,  fill=NA, colour="yellow", linetype=1, size=0.2) +
geom_rect(xmin = -Inf, xmax = 0, ymin = -Inf, ymax = 0,  fill=NA, colour="green", linetype=1, size=0.15) +
geom_rect(xmin = 0, xmax = Inf, ymin = 0, ymax = Inf,  fill=NA, colour="orange", linetype=1, size=0.15) +
geom_rect(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = -3,  fill=NA, colour="darkgrey", linetype=1, size=0.15) +
#geom_point(size=0.666) + 
#geom_point(size=0.666, color="red") + 
geom_text(data=s_cv,aes(label=s_cv[4]),hjust=0.5, vjust=0.5, size=2.226) +
scale_y_continuous(limits=c(-3.5, 3.5), breaks = seq(-6, 6, 1)) + scale_x_continuous(limits=c(-3.5, 3.5), breaks = seq(-6, 6, 1)) + 
labs(x = "out migration cv Z", y = "in migration cv Z") + theme_bw()
print(g_cv)
