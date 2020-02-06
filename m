Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F94215492F
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Feb 2020 17:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgBFQ3c (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Feb 2020 11:29:32 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35764 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727358AbgBFQ3c (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Feb 2020 11:29:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581006570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BT971wG6wPhX7VJFd1sOcOxmL5huobHf2O2WL2kB92A=;
        b=hzml96NWOtUev/1KOdqvT06iku6CxpX0ymx2YaFlLRbikqbJecw++lmOQNg3707MgSLAL3
        S0p/WYJPfCVpidpgjAHvYcRz5VfyATOFTh+iD7LQJ2b5pLjasB/j/iF86mHzou6Q5D8EiW
        J1DKloXAFtrq/B7yUHTly7EZOFmoxjs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-8WeQjg0kMuSKFu-gxApgsw-1; Thu, 06 Feb 2020 11:29:26 -0500
X-MC-Unique: 8WeQjg0kMuSKFu-gxApgsw-1
Received: by mail-qt1-f197.google.com with SMTP id p12so4194822qtu.6
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Feb 2020 08:29:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BT971wG6wPhX7VJFd1sOcOxmL5huobHf2O2WL2kB92A=;
        b=dlYBNNfbzLzmTO7WQ61sPVKkjIHE3/fDUnXV7ObTvw3EKIv+TaxZR0C1vlGrco3sPy
         fv9Du/YulCbCt2iX6rAlWdl7k9F+LOC5FF2if7n56XNzNe7kd1Art9PHxQ+Yg7Nk91Mj
         v2vw5lNHQl15Moptkm9lK/S6mV7YYl9dl2/33fCG65hJ/EJFkINNwnEwUuwfUr3siR+k
         AEK7NAymC6cU1qU1Za5w0Qlbe+uBRM9+9PGY0do/cW9TElH8zRBHw3nWgUdrGW/EUHlS
         ZDSs6TUMLJPKxjSXQ/g2JloUd/DM1OIUGX1fX+ZaE5mzSbU+jbUpg1SDqtRZpwvp2ZrY
         2D3g==
X-Gm-Message-State: APjAAAVRb0MDD6ryiTWTc+pPexgfv3DV0o0BY7g4ja66jTgSkCcTYP4L
        55ay0foNvmZavDJw9HIIVPrREaN12eB8lCLpfBY5dbT14BQNQTxXV7CPyRzeorQr+Y1yGL2XVIo
        0IcU1QNog1H4Yo346hg==
X-Received: by 2002:a37:94d:: with SMTP id 74mr3342079qkj.352.1581006566409;
        Thu, 06 Feb 2020 08:29:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqw79o/OSwP8qcG9zRkYGvX/+TD2xb8/Jp5SJeC8yu8obGrRcXecqs/KUsVKwfDvaLoqKhSpHg==
X-Received: by 2002:a37:94d:: with SMTP id 74mr3342054qkj.352.1581006566202;
        Thu, 06 Feb 2020 08:29:26 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id o55sm1966271qtf.46.2020.02.06.08.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 08:29:25 -0800 (PST)
Date:   Thu, 6 Feb 2020 11:29:22 -0500
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
Subject: Re: [PATCH v5 13/19] KVM: Simplify kvm_free_memslot() and all its
 descendents
Message-ID: <20200206162922.GD695333@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-14-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200121223157.15263-14-sean.j.christopherson@intel.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:51PM -0800, Sean Christopherson wrote:
> Now that all callers of kvm_free_memslot() pass NULL for @dont, remove
> the param from the top-level routine and all arch's implementations.
> 
> No functional change intended.
> 
> Tested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

