Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8ED3C6188
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Jul 2021 19:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbhGLRKi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Jul 2021 13:10:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57027 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234224AbhGLRKi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Jul 2021 13:10:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626109669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TsrLFalCe5nNdE+AKqjeOWu3LTNOiX4cuylRsIPejw8=;
        b=D4QRoI+Ud2U9EKFlScZ0z/1zhyUv871z4qVYJg0p9yxXlRTDWGBvMlfGjXpYgE80IqdYJc
        AgXwyYaZzRx+oQWmDZEqm4bq8Z5u9Yi/Rt29CYT7od0izBXr6OyM0lrWieSbMiZS0DFUtj
        7sJHU/uPshfa0M6XUUDbW56FtAh7O9o=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-MSwG-iiqNhuWXLzDAl1OTQ-1; Mon, 12 Jul 2021 13:07:48 -0400
X-MC-Unique: MSwG-iiqNhuWXLzDAl1OTQ-1
Received: by mail-il1-f198.google.com with SMTP id h17-20020a056e021d91b02902004a17fb0aso12488992ila.3
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Jul 2021 10:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TsrLFalCe5nNdE+AKqjeOWu3LTNOiX4cuylRsIPejw8=;
        b=kVRIF1BVDif5X+/MC2HE2GEZwYY7VokZJp0oHxPWeJ/RnR1ILKJPSLOVzt475+yes0
         2+yM1gKvgbiyL5RKyv8TsUiJhIBQa29h1D8szgwzZcDyQM6sqYXwcD7i0Haw6VDpmx7u
         TReqqIyv2AEFrY9+SI0FYCbaIZZVDbMDjB7LvndzoqZh8VIM0InmjefdPFBBMXNwlAMt
         +fhg+Rvvnzoxx7bsOOGTq0z7ZoZQyGcaob8NTASygHljlVrgkhslQVlCpqjuLhBVq5+N
         ClyvtaYjM+dpz/SF6RO5m0mS91niLQEoC9b9St+J8TRelwiM4AiLW4tqITW6oqKxAime
         nacA==
X-Gm-Message-State: AOAM532srbZrMu4Kg+H1BeLNdOUjrLXEbv+xcOPgYQDSIl2s3v5i8X9k
        LegoepZvvCLEuWU9w4AfbVZWUjsCQc6lqOgTBDxacgtU59AjAOUdvNLL+/iATW2RqIpboJ25vq4
        onFzxa+9XCEtftT+Vpw==
X-Received: by 2002:a92:c0c3:: with SMTP id t3mr6195920ilf.80.1626109667985;
        Mon, 12 Jul 2021 10:07:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwW+FcYNWz+4Ju1xiZ3nfECC1K78r/zSQR3QsIBlAh2kMR8epVZ1JcshyO08RQjWkbEc/wn9A==
X-Received: by 2002:a92:c0c3:: with SMTP id t3mr6195897ilf.80.1626109667825;
        Mon, 12 Jul 2021 10:07:47 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id j24sm3180497ioo.16.2021.07.12.10.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 10:07:47 -0700 (PDT)
Date:   Mon, 12 Jul 2021 19:07:45 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, thuth@redhat.com,
        pbonzini@redhat.com, lvivier@redhat.com, kvm-ppc@vger.kernel.org,
        david@redhat.com, frankja@linux.ibm.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        vivek.gautam@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 1/5] lib: arm: Print test exit status
 on exit if chr-testdev is not available
Message-ID: <20210712170745.wz2jewomlqchmhhb@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-2-alexandru.elisei@arm.com>
 <20210712175155.7c6f8dc3@slackpad.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712175155.7c6f8dc3@slackpad.fritz.box>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jul 12, 2021 at 05:51:55PM +0100, Andre Przywara wrote:
> On Fri,  2 Jul 2021 17:31:18 +0100
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> 
> Hi,
> 
> > The arm64 tests can be run under kvmtool, which doesn't emulate a
> > chr-testdev device. In preparation for adding run script support for
> > kvmtool, print the test exit status so the scripts can pick it up and
> > correctly mark the test as pass or fail.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  lib/chr-testdev.h |  1 +
> >  lib/arm/io.c      | 10 +++++++++-
> >  lib/chr-testdev.c |  5 +++++
> >  3 files changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
> > index ffd9a851aa9b..09b4b424670e 100644
> > --- a/lib/chr-testdev.h
> > +++ b/lib/chr-testdev.h
> > @@ -11,4 +11,5 @@
> >   */
> >  extern void chr_testdev_init(void);
> >  extern void chr_testdev_exit(int code);
> > +extern bool chr_testdev_available(void);
> >  #endif
> > diff --git a/lib/arm/io.c b/lib/arm/io.c
> > index 343e10822263..9e62b571a91b 100644
> > --- a/lib/arm/io.c
> > +++ b/lib/arm/io.c
> > @@ -125,7 +125,15 @@ extern void halt(int code);
> >  
> >  void exit(int code)
> >  {
> > -	chr_testdev_exit(code);
> > +	if (chr_testdev_available()) {
> > +		chr_testdev_exit(code);
> > +	} else {
> > +		/*
> > +		 * Print the test return code in the format used by chr-testdev
> > +		 * so the runner script can parse it.
> > +		 */
> > +		printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
> 
> It's more me being clueless here rather than a problem, but where does
> this "EXIT: STATUS" line come from? In lib/chr-testdev.c I see "%dq",
> so it this coming from QEMU (but I couldn't find it in there)?
> 
> But anyways the patch looks good and matches what PPC and s390 do.

I invented the 'EXIT: STATUS' format for PPC, which didn't/doesn't have an
exit code testdev. Now that it has also been adopted by s390 I guess we've
got a kvm-unit-tests standard to follow for arm :-)

Thanks,
drew


> 
> Cheers,
> Andre
> 
> 
> > +	}
> >  	psci_system_off();
> >  	halt(code);
> >  	__builtin_unreachable();
> > diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
> > index b3c641a833fe..301e73a6c064 100644
> > --- a/lib/chr-testdev.c
> > +++ b/lib/chr-testdev.c
> > @@ -68,3 +68,8 @@ void chr_testdev_init(void)
> >  	in_vq = vqs[0];
> >  	out_vq = vqs[1];
> >  }
> > +
> > +bool chr_testdev_available(void)
> > +{
> > +	return vcon != NULL;
> > +}
> 

