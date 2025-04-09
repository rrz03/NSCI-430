module load ants
module load itk

moving_image=$1
fixed_image=$2
output_tag=$3
# change the path to your own file directories
# moving image is the histology
# fixed image is the block-face image

mesh_size_at_base_level=$4 # make it a variable in the for loop
sampling=$5
neighborhood_size=$6


antsRegistration --verbose 1 --dimensionality 2 --float 0 --collapse-output-transforms 1 \
      --output [${output_tag}_${sampling}_${neighborhood_size}_${mesh_size_at_base_level},${output_tag}Warped_${sampling}_${neighborhood_size}_${mesh_size_at_base_level}.nii.gz,${output_tag}InverseWarped_${sampling}_${neighborhood_size}_${mesh_size_at_base_level}.nii.gz] \
      --interpolation Linear --use-histogram-matching 1 \
      --initial-moving-transform [$fixed_image,$moving_image,1] \
      --transform Similarity[0.1] \
      --metric MeanSquares[$fixed_image,$moving_image,1,$neighborhood_size,Regular,$sampling] \
      --convergence [1000x500x250x100,1e-6,10] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox \
      --transform Affine[0.1] \
      --metric MeanSquares[$fixed_image,$moving_image,1,$neighborhood_size,Regular,$sampling] \
      --convergence [1000x500x250x100,1e-6,10] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox \
      --transform BSplineSyN[0.1,$mesh_size_at_base_level] \
      --metric CC[$fixed_image,$moving_image,1,$neighborhood_size,Regular,$sampling] \
      --convergence [50x25x10x10,1e-6,2] --shrink-factors 12x8x4x2 --smoothing-sigmas 4x3x2x1vox

# submit with sbatch
# for mesh_size_at_base_level in {3,5,10,15,20,25,30,35,40,45,50}; do
      # for sampling in {1,2,3,4,5}; do
          # for neighborhood_size in {5,10,15,20,25,30}; do
              # sbatch -c 1 --mem=80g -t 1-23:59:00 --account=def-amirs /lustre03/project/6001995/rrz03/histology_to_blockface_registration/scripts/registration_2D/MSE_similarity_affine_BsplineSyN.sh $moving_image $fixed_image $output_tag #mesh_size_at_base_level $sampling $neighborhood_size
# done

