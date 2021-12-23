Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A952047E5FB
	for <lists+kvm-ppc@lfdr.de>; Thu, 23 Dec 2021 16:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbhLWPqy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 23 Dec 2021 10:46:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25490 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234588AbhLWPqy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 23 Dec 2021 10:46:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640274413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uB1nnwL2HZ8PjbjUGNX1El7Rll4SqXM6Suq6m/fAuNs=;
        b=FcnTkfQsMFuRtL29kV67lrmqXnND0w4m8qYSDOeZBj9g2WDrCiX9h+DKUqFhRVhjR7+VGz
        w0Kd6LCebScSa+Ds8yh1FmsrmcEf6S1OCKHCKArpuFxP4Yz8JSBxJS3PdVnGXCPyu1njg4
        i5zFjwdhOqiLWYkJ0hWB0MeJAVFsy6w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-Tx8gXVikMfKQBjJW6fgaGQ-1; Thu, 23 Dec 2021 10:46:52 -0500
X-MC-Unique: Tx8gXVikMfKQBjJW6fgaGQ-1
Received: by mail-ed1-f69.google.com with SMTP id ay24-20020a056402203800b003f8491e499eso4752016edb.21
        for <kvm-ppc@vger.kernel.org>; Thu, 23 Dec 2021 07:46:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uB1nnwL2HZ8PjbjUGNX1El7Rll4SqXM6Suq6m/fAuNs=;
        b=4DRnvwbJqrpYqkO3LLhlKvRXiyeur8D1C0wIDSN5zY7GymBukJm7cA5KtCQwk7zdDi
         RKuiNGiunuz0Kmw2UAltGdrQ0usiR6eLe9uqt+pGTNtJJliNptfoufxaaM2vFQM8XjTW
         AOKOQFOh1K6sXbkb4iC+WKnCZgE5OpFoBxgTG9WizPm+J4FAwjrY6unUXyoInhcFKLte
         26sEHeTc2FUfyU7ShhbrFIZejpAa09d/OlDTYe7biQrgTKzl5Ba7ltYZB7Pt/NeB6aTD
         bjT878iQdV+anvFiQ7IbF6mWcrfLm3J2z4Eqpb1iSQ6pwrGogdEO4lyA97pviYOPPAE/
         nDig==
X-Gm-Message-State: AOAM530IgzlOA972Gn7wtLvBfTR5EWf0LT+xVoziUwb2gWDNWWOwWfOA
        O7nim1obJw6LJ7rz0E8i+q9YKO75Ixk5OxTYx6OPoq5FfmgszGDP3wKnk5FDvbiIVkzIazhxbpm
        RQzjlENRu/bwE7S+FvA==
X-Received: by 2002:a05:6402:2550:: with SMTP id l16mr2508435edb.83.1640274411319;
        Thu, 23 Dec 2021 07:46:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJydhAuCChGpdm+Jq2mZ7sl3O26qdebgYB74PXQPGmxSVzdh6inRKcDLWSTXGJ9CsvTtFsdHow==
X-Received: by 2002:a05:6402:2550:: with SMTP id l16mr2508409edb.83.1640274411021;
        Thu, 23 Dec 2021 07:46:51 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id 23sm1862803ejg.213.2021.12.23.07.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:46:50 -0800 (PST)
Date:   Thu, 23 Dec 2021 16:46:47 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>, kvm-ppc@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] scripts/arch-run: Mark migration tests as
 SKIP if ncat is not available
Message-ID: <20211223154647.i66pznu5pt54tr76@gator.home>
References: <20211221092130.444225-1-thuth@redhat.com>
 <ae15b86d-6e4d-78be-74da-845c3ef6b9ba@redhat.com>
 <f8d97780-1d58-3dfb-10cc-eb1b8cd0c25a@redhat.com>
 <a53a5e76-1bc7-075a-f644-2eded9963554@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a53a5e76-1bc7-075a-f644-2eded9963554@redhat.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Dec 21, 2021 at 06:25:30PM +0100, Paolo Bonzini wrote:
> On 12/21/21 11:12, Thomas Huth wrote:
> > On 21/12/2021 10.58, Paolo Bonzini wrote:
> > > On 12/21/21 10:21, Thomas Huth wrote:
> > > > Instead of failing the tests, we should rather skip them if ncat is
> > > > not available.
> > > > While we're at it, also mention ncat in the README.md file as a
> > > > requirement for the migration tests.
> > > > 
> > > > Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/4
> > > > Signed-off-by: Thomas Huth <thuth@redhat.com>
> > > 
> > > I would rather remove the migration tests.  There's really no reason
> > > for them, the KVM selftests in the Linux tree are much better: they
> > > can find migration bugs deterministically and they are really really
> > > easy to debug. The only disadvantage is that they are harder to
> > > write.
> > 
> > I disagree: We're testing migration with QEMU here - the KVM selftests
> > don't include QEMU, so we'd lose some test coverage here.
> > And at least the powerpc/sprs.c test helped to find some nasty bugs in
> > the past already.
> 
> I understand that this is testing QEMU, but I'm not sure that testing QEMU
> should be part of kvm-unit-tests.  Migrating an instance of QEMU that runs
> kvm-unit-tests would be done more easily in avocado-vt or avocado-qemu.
>

Migrating is easier with avocado*, but if we want to migrate kut unit
tests, and the unit tests want to ensure the guest is in a specific state
at the time of the migration, then we'll still need the getchar() stuff.
And, if we need the getchar() stuff, then I think we also need a
lightweight way to test migration, which is currently the ncat-based
run_migration bash function. IOW, I vote we keep the code we have, but I'm
also in favor of people building new test harnesses for the kut *.flat
files which can better exercise QEMU or whatever.

Thanks,
drew

