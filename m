Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D48BDDF2
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 Sep 2019 14:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405148AbfIYMOT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 25 Sep 2019 08:14:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40637 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405481AbfIYMOS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 25 Sep 2019 08:14:18 -0400
Received: by mail-qt1-f194.google.com with SMTP id f7so1218187qtq.7
        for <kvm-ppc@vger.kernel.org>; Wed, 25 Sep 2019 05:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OVI5QcSzb1ogi/NUyHxPnF5WpljeLCICuHCH4hdkAkk=;
        b=UBKXw+KB2suz9U44y3DYouGbrl88Nm90V8Wsw6X6eao3v1Q0ZOHIayVjqW+Ac3JAvt
         BY6j3a/CYJYhIbLmMzgIGsa8RV2A3l9vXW8f9p1ttZxvLTVKnQLShFUp6JQlpw2y4Ekf
         bDDPdMuQ5Wr7VcgyCJKxU/EoDJaxxx7EduDRntUPBHNNBjO0ib4vI0mGe0w0vT4jrR6s
         q8B4JocD6DLLs3AjJKgk1eyUF9CgK4k2G0luzKUrOC9gCPk3JjFCP2aRbvrqJ1w0IgG3
         a30U1ABEbjgWv6xsD/m/zZhSphCGVVOqzC/hWn/nfgEoVjLo+hUjSMo4uZJP5XYQ/n5q
         p5ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OVI5QcSzb1ogi/NUyHxPnF5WpljeLCICuHCH4hdkAkk=;
        b=ZQDbxGctM6DQK6P/aF3pLPvOJ8lM84akVqs/WIX5L2alvcnsLBqxlJV4ofXzVgaKbH
         gHja4r6MN8P3jnLaxejWKkPMtfy7L5A9Bwx8Y5b7RiEK/rZIVXy/1Ew/wcj18CDKxGgU
         4go/pGQGDWg2KfpQ2m+8FYxZcX0noV6CrQsgtoezH0KSs1eF/wLLccG+DDx2i4fhbMt6
         7hQ5+oyX1FXxky89SJMlqBXYmwaC1DscLU8ffY169d9B46upyr7h63vIJSV7IsPuk3cp
         acHnjtHZ3MiAieDCgY4TWt5TQclznImdEnq4crCvgn/4phrErfGL+ZUAFK+KKLywC/6J
         KINw==
X-Gm-Message-State: APjAAAUqDUcngx3AINumXx5s/Wlbf8nx/eM+8V3pa5xWGp6fknA/9jSm
        xXEQMSJ5ZX5eKz+oVthpydRtBQ==
X-Google-Smtp-Source: APXvYqykvxxYrfpTCuPObZS7Ml2gjLGRZXElIM5Y2CTDjEL5CnkfFtmLsczbvBhS+BMu1uKuOdCYXw==
X-Received: by 2002:a0c:a5a5:: with SMTP id z34mr6930777qvz.110.1569413657491;
        Wed, 25 Sep 2019 05:14:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-223-10.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.223.10])
        by smtp.gmail.com with ESMTPSA id h29sm3163953qtb.46.2019.09.25.05.14.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Sep 2019 05:14:16 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iD6BU-0006VE-9u; Wed, 25 Sep 2019 09:14:16 -0300
Date:   Wed, 25 Sep 2019 09:14:16 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH v9 0/8] KVM: PPC: Driver to manage pages of secure guest
Message-ID: <20190925121416.GB21150@ziepe.ca>
References: <20190925050649.14926-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925050649.14926-1-bharata@linux.ibm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Sep 25, 2019 at 10:36:41AM +0530, Bharata B Rao wrote:
> [The main change in this version is the introduction of new
> locking to prevent concurrent page-in and page-out calls. More
> details about this are present in patch 2/8]
> 
> Hi,
> 
> A pseries guest can be run as a secure guest on Ultravisor-enabled
> POWER platforms. On such platforms, this driver will be used to manage
> the movement of guest pages between the normal memory managed by
> hypervisor(HV) and secure memory managed by Ultravisor(UV).
> 
> Private ZONE_DEVICE memory equal to the amount of secure memory
> available in the platform for running secure guests is created.
> Whenever a page belonging to the guest becomes secure, a page from
> this private device memory is used to represent and track that secure
> page on the HV side. The movement of pages between normal and secure
> memory is done via migrate_vma_pages(). The reverse movement is driven
> via pagemap_ops.migrate_to_ram().
> 
> The page-in or page-out requests from UV will come to HV as hcalls and
> HV will call back into UV via uvcalls to satisfy these page requests.
> 
> These patches are against hmm.git
> (https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=hmm)
> 
> plus
> 
> Claudio Carvalho's base ultravisor enablement patches that are present
> in Michael Ellerman's tree
> (https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git/log/?h=topic/ppc-kvm)
> 
> These patches along with Claudio's above patches are required to
> run secure pseries guests on KVM. This patchset is based on hmm.git
> because hmm.git has migrate_vma cleanup and not-device memremap_pages
> patchsets that are required by this patchset.

FWIW this is all merged to Linus now and will be in rc1

Jason
