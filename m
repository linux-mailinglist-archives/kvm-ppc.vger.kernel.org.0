Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79B5403C49
	for <lists+kvm-ppc@lfdr.de>; Wed,  8 Sep 2021 17:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbhIHPKb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 8 Sep 2021 11:10:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58438 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230422AbhIHPKa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 8 Sep 2021 11:10:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631113762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qOXWFEXoU4d1PWQB2jnOUh191rdp073coPYvLg02Gzo=;
        b=fybg4P0xA83O/z5OCQltTRjVx6qxz/HXr4j6gNN7ZQPtnkcUZHG3MY84b9QnI/T01bVEcY
        Qa+h4M2g8tYuWm0B/YxoY7hv7MndI1hXABDGxcG7RoG/YMRSsEamAJsP4WXk+/lYNc0w/V
        ncZO4a/Fbgj6YHTpgA5BNc1IjsXvQ7g=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-0gBoSfExN02smfZ1kWkmYg-1; Wed, 08 Sep 2021 11:09:21 -0400
X-MC-Unique: 0gBoSfExN02smfZ1kWkmYg-1
Received: by mail-ed1-f72.google.com with SMTP id o11-20020a056402038b00b003c9e6fd522bso1239373edv.19
        for <kvm-ppc@vger.kernel.org>; Wed, 08 Sep 2021 08:09:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qOXWFEXoU4d1PWQB2jnOUh191rdp073coPYvLg02Gzo=;
        b=W4WKlEZ3eWQKkl+kbNpI9P3wAlo0+maUqvawrBIqLSFJtAuwxywDNIiL1k63/potLe
         moraN6KumMuGfD2Uv565aLompYqCV5NTGpg7Zdxkpv7ptSidPXoPwSMGiXKMKUIVAQnx
         9GYzk67zTOLYw2QgmZYlV9fU9MuVCbM7fThh1en/cKZ2MYF8sW9NJsTvMrZenMY9jG7t
         vE1Z/knv4eRc+sE4eFLI5dcjn4GyDJOdbqUpB5e9AW6wSXgEm2hpG1RA++6uH232Q892
         dyP0pv+aY88ezdHOomIYdxwtOZf5hFiDdmzAZJ+SIDLDy7XTu/UzIPIaVeiVe5piM43h
         3L4w==
X-Gm-Message-State: AOAM531R7ZaE6+4XL+H4qMKoKbMPuIx8/Vq857xue2f15qgnEIEwWXr0
        OVtTGiG6m8Vj6YU9ADOy5MeF4nWDv4iOlUpxJWM9eoHAj/chcysqwc0FAExoXSVTfah1hPWmCod
        RmF1XIjh1PsfdrIrfsg==
X-Received: by 2002:a50:c299:: with SMTP id o25mr1576713edf.80.1631113760153;
        Wed, 08 Sep 2021 08:09:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjnp+xQJV2TBV697pikqHC83BtR6hOPk6Xeh4PK3nYaAVUley8kE1D6LAnFzw9L4RuDVfVYQ==
X-Received: by 2002:a50:c299:: with SMTP id o25mr1576689edf.80.1631113759944;
        Wed, 08 Sep 2021 08:09:19 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id b15sm1188273ejq.83.2021.09.08.08.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 08:09:19 -0700 (PDT)
Date:   Wed, 8 Sep 2021 17:09:12 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com,
        kvm-ppc@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
        maz@kernel.org, vivek.gautam@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 3/5] run_tests.sh: Add kvmtool support
Message-ID: <20210908150912.3d57akqkfux4fahj@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-4-alexandru.elisei@arm.com>
 <20210907101730.trnsig2j4jmhinyu@gator>
 <587a5f8c-cf04-59ec-7e35-4ca6adf87862@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <587a5f8c-cf04-59ec-7e35-4ca6adf87862@arm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Sep 08, 2021 at 03:33:19PM +0100, Alexandru Elisei wrote:
...
> >> +fixup_kvmtool_opts()
> >> +{
> >> +    local opts=$1
> >> +    local groups=$2
> >> +    local gic
> >> +    local gic_version
> >> +
> >> +    if find_word "pmu" $groups; then
> >> +        opts+=" --pmu"
> >> +    fi
> >> +
> >> +    if find_word "its" $groups; then
> >> +        gic_version=3
> >> +        gic="gicv3-its"
> >> +    elif [[ "$opts" =~ -machine\ *gic-version=(2|3) ]]; then
> >> +        gic_version="${BASH_REMATCH[1]}"
> >> +        gic="gicv$gic_version"
> >> +    fi
> >> +
> >> +    if [ -n "$gic" ]; then
> >> +        opts=${opts/-machine gic-version=$gic_version/}
> >> +        opts+=" --irqchip=$gic"
> >> +    fi
> >> +
> >> +    opts=${opts/-append/--params}
> >> +
> >> +    echo "$opts"
> >> +}
> > Hmm, I don't think we want to write a QEMU parameter translator for
> > all other VMMs, and all other VMM architectures, that we want to
> > support. I think we should add new "extra_params" variables to the
> > unittest configuration instead, e.g. "kvmtool_params", where the
> > extra parameters can be listed correctly and explicitly. While at
> > it, I would create an alias for "extra_params", which would be
> > "qemu_params" allowing unittests that support more than one VMM
> > to clearly show what's what.
> 
> I agree, this is a much better idea than a parameter translator. Using a dedicated
> variable in unittests.cfg will make it easier for new tests to get support for all
> VMMs (for example, writing a list of parameters in unittests.cfg should be easier
> than digging through the scripts to figure exactly how and where to add a
> translation for a new parameter), and it allow us to express parameters for other
> VMMs which don't have a direct correspondent in qemu.
> 
> By creating an alias, do you mean replacing extra_params with qemu_params in
> arm/unittests.cfg? Or something else?

Probably something like this

diff --git a/scripts/common.bash b/scripts/common.bash
index 7b983f7d6dd6..e5119ff216e5 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -37,7 +37,12 @@ function for_each_unittest()
                elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
                        smp=${BASH_REMATCH[1]}
                elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
-                       opts=${BASH_REMATCH[1]}
+               elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
+                       qemu_opts=${BASH_REMATCH[1]}
+               elif [[ $line =~ ^qemu_params\ *=\ *(.*)$ ]]; then
+                       qemu_opts=${BASH_REMATCH[1]}
+               elif [[ $line =~ ^kvmtool_params\ *=\ *(.*)$ ]]; then
+                       kvmtool_opts=${BASH_REMATCH[1]}
                elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
                        groups=${BASH_REMATCH[1]}
                elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then

and all other changes needed to support the s/opts/qemu_opts/ change
should work. Also, an addition to the unittests.cfg documentation.

The above diff doesn't consider that a unittests.cfg file could have
both an 'extra_params' and a 'qemu_params' field, but I'm not sure
we care about that. Users should read the documentation and we
should review changes to the committed unittests.cfg files to avoid
that.

Thanks,
drew

