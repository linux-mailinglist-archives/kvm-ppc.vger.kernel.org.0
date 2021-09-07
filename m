Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08F940270E
	for <lists+kvm-ppc@lfdr.de>; Tue,  7 Sep 2021 12:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhIGKWq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 7 Sep 2021 06:22:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233647AbhIGKWq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 7 Sep 2021 06:22:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631010099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f++tlxFdFC82weLDV66fZEVmzKayy0iCTttWnFQCXr8=;
        b=e6ZsVgtH6oRx1GPqy4h0nkawtKKqgyqd+P/u7N1oLUT3x15wm694WqmzVi4UKAiWDoK1kD
        FuaBKRSHBBE4HYWeEfLeBwB7qGA2WxCFrZ+uy1h9RMWoZEDzKgX3AsU/svPzPDAXs5dF0u
        AFBKlDZCxQ40VMtpyUQYb67I3BHOUHM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-UT7fqhHRP2iU3Ln1AJ6S6g-1; Tue, 07 Sep 2021 06:21:38 -0400
X-MC-Unique: UT7fqhHRP2iU3Ln1AJ6S6g-1
Received: by mail-wm1-f69.google.com with SMTP id j33-20020a05600c48a100b002e879427915so3217474wmp.5
        for <kvm-ppc@vger.kernel.org>; Tue, 07 Sep 2021 03:21:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f++tlxFdFC82weLDV66fZEVmzKayy0iCTttWnFQCXr8=;
        b=VVmNwdUP40fWDttgORrca3UuCRufu4kPvTLJqrAgcR8kgEqp+tn/rGaCevl64pDtfs
         Jz1yHGcF9IvgTYFklKKKbJ9rb/lXeOKojCRooYO2P4bTXGUpb+pJR5IugHfZvkM+g2+y
         UYPkjDqZogY7j7ydSQjUGGm8uD4awAJ2VoyonpPjUhD/Lt53+TkYExnVmdPNpnzZEs5S
         Fl7NUMFCdSw980Qh4x/DoIcFY1xKNyTO9xU0FgbQnAbtzbK4zJXBzdSsIittM5RhPnHe
         f/eHpmZXkORh7RR2K9XXM4tq3Ewckc780PxtzAvzEbifvlpPPGzYagRwqfDMgi1OO+HX
         kWpw==
X-Gm-Message-State: AOAM530yS3X07PgjNQAoSH6mQtjukbTYgQHrEVHINE8/McKMKOuRYhox
        1CP6fs9P8f4zSpXSHrzT/hE+wuNyfiRuQHIdwO4BDKlstI8zmR990YN7Z7LtlkyXeUFBs/M2c0S
        34yGNbzCyhkH8PlNPiw==
X-Received: by 2002:a05:6000:1563:: with SMTP id 3mr18583609wrz.139.1631010097441;
        Tue, 07 Sep 2021 03:21:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVgROHRJDcbz9ILwMhdnSZ3oJA6YdR1KgI9MywkZ1Cjk4U3iVAKCDYVZQ+gA4/zuyHOdxqyQ==
X-Received: by 2002:a05:6000:1563:: with SMTP id 3mr18583578wrz.139.1631010097179;
        Tue, 07 Sep 2021 03:21:37 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id p5sm11270858wrd.25.2021.09.07.03.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 03:21:36 -0700 (PDT)
Date:   Tue, 7 Sep 2021 12:21:35 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com,
        kvm-ppc@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
        maz@kernel.org, vivek.gautam@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 4/5] scripts: Generate kvmtool
 standalone tests
Message-ID: <20210907102135.i2w3r7j4zyj736b5@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-5-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702163122.96110-5-alexandru.elisei@arm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Jul 02, 2021 at 05:31:21PM +0100, Alexandru Elisei wrote:
> Add support for the standalone target when running kvm-unit-tests under
> kvmtool.
> 
> Example command line invocation:
> 
> $ ./configure --target=kvmtool
> $ make clean && make standalone
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  scripts/mkstandalone.sh | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index 16f461c06842..d84bdb7e278c 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -44,6 +44,10 @@ generate_test ()
>  	config_export ARCH_NAME
>  	config_export PROCESSOR
>  
> +	if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "arm" ]; then
> +		config_export TARGET
> +	fi

Should export unconditionally, since we'll want TARGET set
unconditionally.

> +
>  	echo "echo BUILD_HEAD=$(cat build-head)"
>  
>  	if [ ! -f $kernel ]; then
> @@ -59,7 +63,7 @@ generate_test ()
>  		echo 'export FIRMWARE'
>  	fi
>  
> -	if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
> +	if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then

I think it would be better to ensure that ENVIRON_DEFAULT is "no" for
TARGET=kvmtool in configure.


>  		temp_file ERRATATXT "$ERRATATXT"
>  		echo 'export ERRATATXT'
>  	fi
> @@ -95,12 +99,8 @@ function mkstandalone()
>  	echo Written $standalone.
>  }
>  
> -if [ "$TARGET" = "kvmtool" ]; then
> -	echo "Standalone tests not supported with kvmtool"
> -	exit 2
> -fi
> -
> -if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> +if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && \
> +		[ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
>  	echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
>  	exit 2
>  fi
> -- 
> 2.32.0
>

Thanks,
drew 

