Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F3A153AF5
	for <lists+kvm-ppc@lfdr.de>; Wed,  5 Feb 2020 23:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgBEW2k (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 5 Feb 2020 17:28:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34994 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727415AbgBEW2h (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 5 Feb 2020 17:28:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580941716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xN2n9jkJvkSR0RH/zWMkRvEj2quGdHH6HsawLgUOQOY=;
        b=iApYAl9yv6I1Bh97IB2lo6sf8+RYIKr6mH/HP0P4pzfLX6KSdCc8PFmzIGAGDzcArmo8Xd
        /1FT0cx4FBvoNU89Fb9cYotDIApzO5vHrzfI/84L2xEbrtPPouyn9IE8FS5CenbD6PnzXu
        0MeOvtZOe5Z63znWPoCl1MoIaDZ4xe4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-9wyyYvdNM2qKKMbuoLIeMg-1; Wed, 05 Feb 2020 17:28:34 -0500
X-MC-Unique: 9wyyYvdNM2qKKMbuoLIeMg-1
Received: by mail-qk1-f200.google.com with SMTP id q2so2290358qkq.19
        for <kvm-ppc@vger.kernel.org>; Wed, 05 Feb 2020 14:28:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xN2n9jkJvkSR0RH/zWMkRvEj2quGdHH6HsawLgUOQOY=;
        b=EPoCfqPg86NFGi33qj1U3iUuz0anq6P7UKph2zCRXSsobSrkfw/2TQKmXVThG3ayGt
         EuvOBRreeQ36AeyCczLb3FC/9t6OcNDDALHYl2EIuLpgvagnnyjeGGv6rVjq5J9oiVLE
         JxrNKEmBgG210EUAmw8Bw8Bh+CeXoKWRgNrS7rO6L1bxz+l3tL3YuxZ/mfDoNp2Ti13P
         gEUwXbllInDRZzayK/aW9FhbyApSiivVbzBIlcMsr1C/F8ASKag4Bml7UeYmidRJCCE4
         7+mTQXOmtRbkbRYbsh0mLoT/2AOrMY8IaIpem2n7Z8rIWn0JRY5yoOy+3o4HTOmPWPAo
         Tp2w==
X-Gm-Message-State: APjAAAUFwIb8oGDDJ7khW61/wPGSq5DyteB3pxSn21HJ1eXr8Jm7FOaZ
        ihU//DcokK6bHJoeBFg9OVZVWxIkR1MLuUbEJTfwwftUVoEMmM0/cd6bOijJGcMLqAcqFtWHwRX
        mLXCOFksKNpP3HjfZlw==
X-Received: by 2002:a05:620a:a46:: with SMTP id j6mr13684qka.164.1580941714103;
        Wed, 05 Feb 2020 14:28:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqzgDC/fBZ4GnRbk3BQEXE+eWIhbbieAb4nE+MGEKdPSLikBImrRnbk5qAuaCcwE1K66PslinA==
X-Received: by 2002:a05:620a:a46:: with SMTP id j6mr13650qka.164.1580941713724;
        Wed, 05 Feb 2020 14:28:33 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id c184sm503353qke.118.2020.02.05.14.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 14:28:33 -0800 (PST)
Date:   Wed, 5 Feb 2020 17:28:29 -0500
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
Subject: Re: [PATCH v5 03/19] KVM: Don't free new memslot if allocation of
 said memslot fails
Message-ID: <20200205222829.GF387680@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-4-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200121223157.15263-4-sean.j.christopherson@intel.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:41PM -0800, Sean Christopherson wrote:
> The two implementations of kvm_arch_create_memslot() in x86 and PPC are
> both good citizens and free up all local resources if creation fails.
> Return immediately (via a superfluous goto) instead of calling
> kvm_free_memslot().
> 
> Note, the call to kvm_free_memslot() is effectively an expensive nop in
> this case as there are no resources to be freed.

(I failed to understand why that is expensive.. but the change looks OK)

> 
> No functional change intended.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

