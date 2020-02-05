Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77170153B3B
	for <lists+kvm-ppc@lfdr.de>; Wed,  5 Feb 2020 23:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgBEWpZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 5 Feb 2020 17:45:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36032 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727389AbgBEWpV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 5 Feb 2020 17:45:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580942719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qhu3K4UfMyr9rLuPVrEXyLiBiRw+0bLNH6EYh61xjr4=;
        b=XYYIerHForgEJm1bmnDiaCU8X52LECPVfk5BEnHr8pgT2ETQiFlrNX2vmrVeE517TV/aNA
        7Bc8b2ZMF7yFm5KeCy0JZK97GYECGWUu+836UnwYkEoYZx1ZHrwLsQVZcU3Jr0hZu3mZd/
        BidUPuYtBCvqSpFmAEsmvZYBKKF0ndM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-cfDsvCz-Nhe-TFyPhoqQzQ-1; Wed, 05 Feb 2020 17:45:17 -0500
X-MC-Unique: cfDsvCz-Nhe-TFyPhoqQzQ-1
Received: by mail-qv1-f69.google.com with SMTP id dc2so2480764qvb.7
        for <kvm-ppc@vger.kernel.org>; Wed, 05 Feb 2020 14:45:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qhu3K4UfMyr9rLuPVrEXyLiBiRw+0bLNH6EYh61xjr4=;
        b=QFSIS1Fsf/VOvUBMX2PAyTLkfv94FqR7lV6org7YlvO/A93IJcoR0BAZsr7FBsaIMn
         xkkwkNlH4UAmRb1sYG09KZbgiblIwAYEa2a6B9TUxXgXzAna7mzcqTPAT6lKSAiz8hh5
         nUh6KT7dMYFNyJpQ7S0Q7CFSuFhkwUJMm6CgoPAPxxBbAPtlUVqp4aezd3DRMmjHVV/F
         lZy3TvEaLe7bChmukWNGyYS1ruUSIc1QL+VKBXJzfZytD+LX+2OudhigZETuvsO3B7Tj
         8LPJ/6jLmRrUB2FOEER/GjDmStZrgPgjAkw+zxI2R8J5ZUqqbCywr9wl14h6B7ovqfLc
         a7fQ==
X-Gm-Message-State: APjAAAW5maXkOsQNgmEa2E9TZnhOmMgLYEl2M4X9N6vhjDtj8eDV1epH
        O9cLI5ifprvdmzQ8ilGznU8TjjdEVJMWxVWwn9mF8iaJW37yX6Xwfq1kAkJTAFhXPpg1iMc9nXs
        VwAg02uQuNrXv6RQXAw==
X-Received: by 2002:a05:620a:1654:: with SMTP id c20mr61824qko.116.1580942717358;
        Wed, 05 Feb 2020 14:45:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqyAvhOweFr4KXXnP5Mb9+7dhUBLh1Z13T+81iDjtWqZt6EK3UE5xX8DXWaSS5tvfd+S4d7C7g==
X-Received: by 2002:a05:620a:1654:: with SMTP id c20mr61812qko.116.1580942717130;
        Wed, 05 Feb 2020 14:45:17 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id x22sm615496qtq.30.2020.02.05.14.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 14:45:16 -0800 (PST)
Date:   Wed, 5 Feb 2020 17:45:13 -0500
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
Subject: Re: [PATCH v5 06/19] KVM: Drop kvm_arch_create_memslot()
Message-ID: <20200205224513.GH387680@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-7-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200121223157.15263-7-sean.j.christopherson@intel.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:44PM -0800, Sean Christopherson wrote:
> Remove kvm_arch_create_memslot() now that all arch implementations are
> effectively nops.  Removing kvm_arch_create_memslot() eliminates the
> possibility for arch specific code to allocate memory prior to setting
> a memslot, which sets the stage for simplifying kvm_free_memslot().
> 
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

