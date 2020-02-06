Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94DE1154EE8
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Feb 2020 23:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgBFWaH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Feb 2020 17:30:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55882 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726536AbgBFWaH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Feb 2020 17:30:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581028206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y9cBxEKgtYZ4SHZJ2KCZ291mafsQUmmbyOmTI5C6x9c=;
        b=XtU6R1g1DzR7pDkOvp+BNKtATHbXUm90+/6GQRFQ9uNmo8psreNAsY2ftxMiGhOS92tTCK
        FqguwxiD1MhiFn+CRt1r9PB391onsqLQdmK/iW/zXKIraySs/NP8xsLMIUIcxDY1chJMPP
        8eIvakGDCKnQ+J8Mo6ManhkTvzGnOY8=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-BWFnmuO9NFK_NtXMongqzA-1; Thu, 06 Feb 2020 17:30:05 -0500
X-MC-Unique: BWFnmuO9NFK_NtXMongqzA-1
Received: by mail-qt1-f199.google.com with SMTP id b5so276132qtt.10
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Feb 2020 14:30:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y9cBxEKgtYZ4SHZJ2KCZ291mafsQUmmbyOmTI5C6x9c=;
        b=XeFd3IS+aTiMJne8dxLEjC0bmFuOYvWqlmSV2XIJSsP72EJY9Q2DaTogKxB9CsSlFJ
         pMjkRB/1XOjqkF0eoYHFM4RhGUBnIowM4WLA5EBvo/6lo34EhbtenlNTzaz7uqWwHa0C
         Wcg7M/1FnQLeypkA5Mf9yF5NsbUxngZ6+w1VqwgzaJeEGAAw4O39IbqVuvx8UybGyyEj
         h326sZaEsI3Old/19tGJPFczZehOTD+Ddx5ktXyPihjglRkqAY9J5zk6HaLm9AFShOgf
         IGODpoThsm/fqwnNls/FaUh5Q9GQ39ElEb5pfsHBoyxZwqs90p+HnoR4bTcdHXMOB0hR
         M11A==
X-Gm-Message-State: APjAAAU7GIHdXtn8GywhYbRdvMyyNnqeeLtBBA9ZWGXCLyxHfUqTSsQt
        Y6JEs624HXg1b+xFCl5LFCZsHtoJmSC+AOtVtpA9XLo69hOoIggGy5W8B6nigMSpFO4C6DIZ1Cl
        t3Eh5HJ6uYMSCHbM7ig==
X-Received: by 2002:a37:7884:: with SMTP id t126mr4700924qkc.288.1581028204602;
        Thu, 06 Feb 2020 14:30:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqzvEhS0XgXcsen5IJpPtTelaoRM0D8F8yYe4NbZxtsmBW+xmvTRWnxA6Vkem/WNxI4KksN37A==
X-Received: by 2002:a37:7884:: with SMTP id t126mr4700901qkc.288.1581028204379;
        Thu, 06 Feb 2020 14:30:04 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id z185sm352349qkb.116.2020.02.06.14.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 14:30:03 -0800 (PST)
Date:   Thu, 6 Feb 2020 17:30:01 -0500
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
Subject: Re: [PATCH v5 19/19] KVM: selftests: Add test for
 KVM_SET_USER_MEMORY_REGION
Message-ID: <20200206223001.GJ700495@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-20-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200121223157.15263-20-sean.j.christopherson@intel.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:57PM -0800, Sean Christopherson wrote:
> Add a KVM selftest to test moving the base gfn of a userspace memory
> region.  Although the basic concept of moving memory regions is not x86
> specific, the assumptions regarding large pages and MMIO shenanigans
> used to verify the correctness make this x86_64 only for the time being.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

(I'm a bit curious why write 2 first before 1...)

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

