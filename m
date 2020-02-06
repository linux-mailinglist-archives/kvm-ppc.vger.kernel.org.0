Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A85BE1548E4
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Feb 2020 17:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbgBFQOZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Feb 2020 11:14:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56705 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727478AbgBFQOZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Feb 2020 11:14:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581005663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zD2zZ3ak+8ZDNOjl3NQ0JmucKO3t2SwHGRlR5dLOuQs=;
        b=PtsaSzBpn3wylYv5IunK8BOn70EWXGlvuFY30Y1fcc+XcfmzEXqvQvpAfGZXCGWj9Hg2pQ
        pGhecRCqXelNpzx/r+icVLmhCuQVLb+KZyidprHuL58DNNQSqiyj5iIQEmyy0KUwx2XZli
        gTKaWIa/3+gF7Hjd6a2xP322IUXnXN8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-3Wn6DNppOwut6WBWDeooog-1; Thu, 06 Feb 2020 11:14:21 -0500
X-MC-Unique: 3Wn6DNppOwut6WBWDeooog-1
Received: by mail-qt1-f198.google.com with SMTP id x8so4162248qtq.14
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Feb 2020 08:14:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zD2zZ3ak+8ZDNOjl3NQ0JmucKO3t2SwHGRlR5dLOuQs=;
        b=lObFYBQ+xSBNX2ANpeLupzzp07GffWsXUOriVsdokKgAAgFUnu9msk1yWnDG9QY8zG
         1cHbVkIG2/oYaX1R491vSIe35ynAg5GaRy7rVIJl6noy9/eO6rMFeY6t+YfZAXYlCZ95
         yAYNs2KIPOcLBojmw99wD0woR3EyqIvAwEa0KZamgHsjBu3GVJLg55nyEBCB6lvV1qIY
         I5DeXIHIwX95HDNlpAGEQFPLgHWCL5i8YylFGsD36oCNdxwOaAU9/a1L1ZUJhGW6aSu2
         4Hf/O6ERbQqRrkgTruLfZh8NcYBXromASxz72FJRkPToAXUSJfxQ2OVRnam7m7d0CPVn
         auIw==
X-Gm-Message-State: APjAAAVymvPiv7V3OqMIK4K+y/cVrLBGDkvl37HQFu/fdQDBQ8XZj5cW
        9/Me1etoJdl8JbWR60uc9xe0BB9psRPmqjQ9i/FEOHS0Udi+HKjMF2p+iCWZroQs8loH0oJevG5
        MJ9XAQpzWp/H5ejISmA==
X-Received: by 2002:ac8:6f27:: with SMTP id i7mr3235314qtv.253.1581005660654;
        Thu, 06 Feb 2020 08:14:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqzCPmrX47EJacBvj/8AwtDA4K9i5Vm/4QY2t/yuwCUp2i98pBnWQFyP1cxUVQ9RQgxjF7p4Wg==
X-Received: by 2002:ac8:6f27:: with SMTP id i7mr3235285qtv.253.1581005660385;
        Thu, 06 Feb 2020 08:14:20 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id 136sm1590227qkn.109.2020.02.06.08.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 08:14:19 -0800 (PST)
Date:   Thu, 6 Feb 2020 11:14:15 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 12/19] KVM: Move memslot deletion to helper function
Message-ID: <20200206161415.GA695333@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-13-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200121223157.15263-13-sean.j.christopherson@intel.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:50PM -0800, Sean Christopherson wrote:
> Move memslot deletion into its own routine so that the success path for
> other memslot updates does not need to use kvm_free_memslot(), i.e. can
> explicitly destroy the dirty bitmap when necessary.  This paves the way
> for dropping @dont from kvm_free_memslot(), i.e. all callers now pass
> NULL for @dont.
> 
> Add a comment above the code to make a copy of the existing memslot
> prior to deletion, it is not at all obvious that the pointer will become
> stale during sorting and/or installation of new memslots.

Could you help explain a bit on this explicit comment?  I can follow
up with the patch itself which looks all correct to me, but I failed
to catch what this extra comment wants to emphasize...

Thanks,

> 
> Note, kvm_arch_commit_memory_region() allows an architecture to free
> resources when moving a memslot or changing its flags, e.g. x86 frees
> its arch specific memslot metadata during commit_memory_region().

-- 
Peter Xu

