Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D86153AB3
	for <lists+kvm-ppc@lfdr.de>; Wed,  5 Feb 2020 23:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgBEWIc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 5 Feb 2020 17:08:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29547 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727109AbgBEWI3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 5 Feb 2020 17:08:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580940508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6bIsTUAiuk9WkuPnamAI4/KWATTYkjxm0pqVjMTg08w=;
        b=bKf1AqmHUFtCPg2m+npOgldfaxMNPunbYteHHWlRv6hayISOdCA3hWCx0af+epd8YFkPMI
        eX64I3AbDsHOUWbnU6WK/Rm2Oaw050NIuyVGQOy2VXUdRDkAXNrQD+NMp7ylI+Kk1rnu8C
        +SG0JLW4nn/cYcMYCGYWPbe5rBlGOmc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-UTcBOL8oNN26Tz0F-RrOLA-1; Wed, 05 Feb 2020 17:08:27 -0500
X-MC-Unique: UTcBOL8oNN26Tz0F-RrOLA-1
Received: by mail-qt1-f199.google.com with SMTP id h11so2414392qtq.11
        for <kvm-ppc@vger.kernel.org>; Wed, 05 Feb 2020 14:08:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6bIsTUAiuk9WkuPnamAI4/KWATTYkjxm0pqVjMTg08w=;
        b=Mly5aNvWMrp0Y+izIm2OktrK+XS8vJbCAt/kipzM/dBmivL4UyEib6gcVVs8eRwXYi
         hWa2V2Jx1ZSQAmy9Ztiat7dHfw4o1d9BVEBky0RAIFj2UEmyRjRf9BB6O9Jf12yKTe+b
         uFz3b4frp7jxoEnvxRQWSSpwzWtvjZLLGeJAR17QGPtfIbP8xutuHKngw4yGmFWklltd
         NKdJSwX2UqEg978rHwEmZGiLXZ+M1qiAjSbvHj8iSPGRK+kRzE1jO3FKFvbpygeBdfWN
         aL+8vCjmEgdCvLoaIB/q/urgd/ozdc1lOxoXeFwN/bUXbntPLytkrRgFL1JEnenb42My
         /NNg==
X-Gm-Message-State: APjAAAVFiiuIm/QsADTgfYR0BQwnM6kVTfLAXcjn0MrKzlIz9u3/cKNK
        BG+bQvwU2DY5VZcPlEeQ17uhTuN8iYnrhWYnO5/7bYAZnfevCVI4f92agPpAYEDeM9cRX01L3Zk
        G8QtAJIWTweFSsxV+bw==
X-Received: by 2002:ac8:4e94:: with SMTP id 20mr35228161qtp.335.1580940506681;
        Wed, 05 Feb 2020 14:08:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqxhvNH1iy5q/tis+s7hwuGT0ebc3dkr1uSM1KA4FQeWbspaaAJT384pUzbSiV9AUE83qayDAQ==
X-Received: by 2002:ac8:4e94:: with SMTP id 20mr35228131qtp.335.1580940506464;
        Wed, 05 Feb 2020 14:08:26 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id t16sm458993qkg.96.2020.02.05.14.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 14:08:25 -0800 (PST)
Date:   Wed, 5 Feb 2020 17:08:22 -0500
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
Subject: Re: [PATCH v5 02/19] KVM: Reinstall old memslots if arch preparation
 fails
Message-ID: <20200205220822.GE387680@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200121223157.15263-3-sean.j.christopherson@intel.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:40PM -0800, Sean Christopherson wrote:
> Reinstall the old memslots if preparing the new memory region fails
> after invalidating a to-be-{re}moved memslot.
> 
> Remove the superfluous 'old_memslots' variable so that it's somewhat
> clear that the error handling path needs to free the unused memslots,
> not simply the 'old' memslots.
> 
> Fixes: bc6678a33d9b9 ("KVM: introduce kvm->srcu and convert kvm_set_memory_region to SRCU update")
> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

