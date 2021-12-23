Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A69847E608
	for <lists+kvm-ppc@lfdr.de>; Thu, 23 Dec 2021 16:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244383AbhLWPuo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 23 Dec 2021 10:50:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54707 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244372AbhLWPun (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 23 Dec 2021 10:50:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640274642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a3jSVSDAuP2qAp+ACszG/Ca5tr0drEgmWt1vLgLHWtg=;
        b=VFGEkU3cExqhUWkSNGmSrA86QB0F+g3W5YtURMUGh75SZP+S84PzmUtilfA9gp6s0FZug0
        MfUt6Ygwh7NadBZX39FaRMwo3qgm55WQuaJ4cgkXWfb2kdMznc0PBBUyQXmxJXPOEWNba4
        UVAJhH11KxX8fi5EiatN9zlBdtMGfjY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613--bJsLxzpOJCuGAmzoxDrhg-1; Thu, 23 Dec 2021 10:50:41 -0500
X-MC-Unique: -bJsLxzpOJCuGAmzoxDrhg-1
Received: by mail-ed1-f71.google.com with SMTP id s12-20020a50ab0c000000b003efdf5a226fso4788241edc.10
        for <kvm-ppc@vger.kernel.org>; Thu, 23 Dec 2021 07:50:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a3jSVSDAuP2qAp+ACszG/Ca5tr0drEgmWt1vLgLHWtg=;
        b=RZ9ELtiM81fwZi/mvQ69OGZmLlh3Bxeik5H5rlutjhXIx9drE1fpewJhx6eltC01XC
         DrSa8KmVEQ9paFpiwcQ5q55ZIkGR/bxWGd055/gQhedZ9C54KvBQe189gZUuvb3jzjHq
         jPp8QAyBeeLglSya12K6lhLSAJ6KX17HzP0FVukWOHmqpVd6CHK+YyZLPBxBlYu/Pcty
         W71C+UZ4KwCY3dNCA7Ae2EcUZ1ZOSZige+vlHjhAoGaJM59wAby+xj7Cym9urksq6Isw
         8KvttnWWBpdAip5u++bazbVcQJX2QJVJ4TaOq522PaaWqz4p9LqxtKo2tDiQYAY7MIiP
         9t7w==
X-Gm-Message-State: AOAM530u5nGsABvZxYhCBdA1abPM4pgz6AkaJSicMV3P8ky7LwK2SRJK
        elT1+yEj/mA+DfCj/3/EUiAgawZDCOE4Nnn4byn+QrJRasMwE1mHuA21dXdgylP9n1MNwWUltmM
        QhFWYdA4sUXLT+uWXBA==
X-Received: by 2002:aa7:d554:: with SMTP id u20mr2537246edr.322.1640274640187;
        Thu, 23 Dec 2021 07:50:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjvcZiYnGos0+nrz5J+V9LCLpx9dQwps5e8qMO+vSV93vXatkdIeEM4z088mrh1QqbWAP84g==
X-Received: by 2002:aa7:d554:: with SMTP id u20mr2537236edr.322.1640274640005;
        Thu, 23 Dec 2021 07:50:40 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id dd5sm1897720ejc.99.2021.12.23.07.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:50:39 -0800 (PST)
Date:   Thu, 23 Dec 2021 16:50:37 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm-ppc@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] scripts/arch-run: Mark migration tests as
 SKIP if ncat is not available
Message-ID: <20211223155037.rt5mhnsepc3u6mra@gator.home>
References: <20211221092130.444225-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221092130.444225-1-thuth@redhat.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Dec 21, 2021 at 10:21:30AM +0100, Thomas Huth wrote:
> Instead of failing the tests, we should rather skip them if ncat is
> not available.
> While we're at it, also mention ncat in the README.md file as a
> requirement for the migration tests.
> 
> Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/4
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  README.md             | 4 ++++
>  scripts/arch-run.bash | 2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/README.md b/README.md
> index 6e6a9d0..a82da56 100644
> --- a/README.md
> +++ b/README.md
> @@ -54,6 +54,10 @@ ACCEL=name environment variable:
>  
>      ACCEL=kvm ./x86-run ./x86/msr.flat
>  
> +For running tests that involve migration from one QEMU instance to another
> +you also need to have the "ncat" binary (from the nmap.org project) installed,
> +otherwise the related tests will be skipped.
> +
>  # Tests configuration file
>  
>  The test case may need specific runtime configurations, for
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 43da998..cd92ed9 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -108,7 +108,7 @@ run_migration ()
>  {
>  	if ! command -v ncat >/dev/null 2>&1; then
>  		echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
> -		return 2
> +		return 77
>  	fi
>  
>  	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
> -- 
> 2.27.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

