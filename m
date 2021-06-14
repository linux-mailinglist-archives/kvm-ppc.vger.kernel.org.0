Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451F23A5EBB
	for <lists+kvm-ppc@lfdr.de>; Mon, 14 Jun 2021 11:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhFNJDz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 14 Jun 2021 05:03:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232565AbhFNJDy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 14 Jun 2021 05:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623661310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vu71pFISFQB26ccLvg0CQj6wZuEmNrd515lFL21+3Sk=;
        b=QvbVYIAx72B/tqDOtFZsqrli/unFbgNj+9iu7LuqhwqWNtlQv2xtSEYPRhIzWJJKO0sub1
        F56PmUpymaCigIho6vNfGfAQfkNAuQmkvm2f6vm5uLGAwt6GYaoUyjPJglGTQtnLsOCwup
        uw1EklJil07fcS/SeKYG3Ky49yWsAA4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-ws-VoguOPfGPtNNhKLHJkw-1; Mon, 14 Jun 2021 05:01:48 -0400
X-MC-Unique: ws-VoguOPfGPtNNhKLHJkw-1
Received: by mail-ed1-f71.google.com with SMTP id v12-20020aa7dbcc0000b029038fc8e57037so1704363edt.0
        for <kvm-ppc@vger.kernel.org>; Mon, 14 Jun 2021 02:01:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vu71pFISFQB26ccLvg0CQj6wZuEmNrd515lFL21+3Sk=;
        b=gf8jrg2T8+8D9F2ZJ4dA979GPO3ZtxBrEQqCw31dl5WecX2PN3vWXUBxXkfysA2BNH
         O1JZCsa3MMIHbMqX5R/sZ5bbsBNM4X12o+0mlXd5EyXhQvhnj0sJvSdvserz6un7Ey/3
         QTEFQxShoTSlmb8d68+2tq+p7QTiuveQQoDPXRmX5W3gFeg/ccRuSM+RKNF8381Fs+Cp
         ScFY+Cs10sL5+LdHUFTp2o+BXtnhZB1EdIIyqua1ACguvm+py3hZhgFsnlTTfBv5kcVR
         5UVK6Ynv1DEFIUT8s2KjnFqMXzoyFI6qlOzpZrMMEY8j8rUWxxFGqRj/frWbnr1UbY61
         WFNQ==
X-Gm-Message-State: AOAM5314z0uUSusOm7kpuLRIqNOATOUnefVpZy0nmVrVIUAvd9EF8mk9
        n7EV1seqmBmD+n/gsyr7y9sOMhCm8uhfZ9cWs3VhIum3B33LYmKi7pHF6PTkzDcTjsQzbU17MxU
        gzoQWRs4mUrr0Rid8XQ==
X-Received: by 2002:a17:906:919:: with SMTP id i25mr13807856ejd.171.1623661306891;
        Mon, 14 Jun 2021 02:01:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+fLbnuHGety/JfKAcniNuROzvJXDxZM4MObP9ZDsQ/Xs26Tw0DmHFHnS/gasdb1Ql3S2RTg==
X-Received: by 2002:a17:906:919:: with SMTP id i25mr13807831ejd.171.1623661306669;
        Mon, 14 Jun 2021 02:01:46 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id h22sm8094337edv.0.2021.06.14.02.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 02:01:46 -0700 (PDT)
Date:   Mon, 14 Jun 2021 11:01:44 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/7] README.md: add guideline for
 header guards format
Message-ID: <20210614090144.q76g5mgmuno47snj@gator.home>
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-2-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609143712.60933-2-cohuck@redhat.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Jun 09, 2021 at 04:37:06PM +0200, Cornelia Huck wrote:
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  README.md | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/README.md b/README.md
> index 24d4bdaaee0d..687ff50d0af1 100644
> --- a/README.md
> +++ b/README.md
> @@ -156,6 +156,15 @@ Exceptions:
>  
>    - While the kernel standard requires 80 columns, we allow up to 120.
>  
> +Header guards:
> +
> +Please try to adhere to adhere to the following patterns when adding

Double 'to adhere'

Thanks,
drew

> +"#ifndef <...> #define <...>" header guards:
> +    ./lib:             _HEADER_H_
> +    ./lib/<ARCH>:      _ARCH_HEADER_H_
> +    ./lib/<ARCH>/asm:  _ASMARCH_HEADER_H_
> +    ./<ARCH>:          ARCH_HEADER_H
> +
>  ## Patches
>  
>  Patches are welcome at the KVM mailing list <kvm@vger.kernel.org>.
> -- 
> 2.31.1
> 

