Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BBB3AF8C3
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 00:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhFUWrY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Jun 2021 18:47:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232172AbhFUWrX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 21 Jun 2021 18:47:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624315507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Ww1F8FpJZaZo8phfEn0boIIG2NuubuAivva/xm/sdo=;
        b=ejp16SJbO1knmQ6xrUIXMQvRR184jd9PfqcVkB6L8oIHDeNZUKAlusfII1lxE7pMgbsJA8
        0pl35Wpti7kSKfUqxBlPvjko6V1sXk8OOn0YrHr33oma8rAQJ3Jut7HGvR+JYIkBAJflDI
        nsniSk3R0zLz6L0YLF/wf6/xhf0It5I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-fuA4xl2jNzy5E6IwOQvl3w-1; Mon, 21 Jun 2021 18:45:06 -0400
X-MC-Unique: fuA4xl2jNzy5E6IwOQvl3w-1
Received: by mail-wr1-f69.google.com with SMTP id u18-20020a5d6ad20000b0290123314c5505so62190wrw.20
        for <kvm-ppc@vger.kernel.org>; Mon, 21 Jun 2021 15:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Ww1F8FpJZaZo8phfEn0boIIG2NuubuAivva/xm/sdo=;
        b=h8M08WCl1cq8r4R+5M/Uq6BTyuEMQlNAGWuXa4qV2xNFOuHsXTQQMjGt0qSM/bBtKC
         PRRHU00syS72zFpzoAY/Qwnrpy0GUifM5m8J0rL69WXbXMQwUnF/ZOHqBM/MPmi75rXL
         mJmiUpm/wy5j28A1uHp4M8aiO6PKkxxNfio2XSohxzuqEJPKe+q+2LmY5ZnBn7QsbxDx
         gizCk0SKnFUBSTPWu3HKGGyX/NwWhs125bnru7VTKYj3tZRmA88XtdaKwI4sqMLObAWv
         j6meoFX97YxdlVa0mBoU/2ue+LIxudLz6eDqglrYtEUYApInLHr7FFD2ikMnil+Csagk
         ZgBg==
X-Gm-Message-State: AOAM531NwPMTMeIEScOyyzbI2HhSKCrDuDSXs/pbuVQI1C2K114kO+Ly
        JWRUQC1koGfb5vIt4xSv1OcrTKQNX5hlgt0slrnyfTXG+ymZVIXgamLee2Y0WWlM6I8Dnwnpf5g
        4kH1aBr/zTnjBvyl/+A==
X-Received: by 2002:a05:6000:2a3:: with SMTP id l3mr831626wry.395.1624315505342;
        Mon, 21 Jun 2021 15:45:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlFclcimGGjPltn0DAxtLrcGDZCJlLH0UWL7OyUr1L1pgHHRNr4wPtn6Uw/OIdBFiF9M4JrQ==
X-Received: by 2002:a05:6000:2a3:: with SMTP id l3mr831601wry.395.1624315505122;
        Mon, 21 Jun 2021 15:45:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id d15sm18577278wri.58.2021.06.21.15.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 15:45:04 -0700 (PDT)
Subject: Re: [PATCH v12 2/7] KVM: stats: Add fd-based API to read binary stats
 data
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Fuad Tabba <tabba@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <20210618222709.1858088-1-jingzhangos@google.com>
 <20210618222709.1858088-3-jingzhangos@google.com>
 <0cde024e-a234-9a10-5157-d17ba423939e@redhat.com>
 <CAAdAUtiL6DwJDWLLmUqct6B6n7Zaa2DyPhpwKZKb=cpRH+8+vQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aa1d0bd9-55cf-161a-5af9-f5abde807353@redhat.com>
Date:   Tue, 22 Jun 2021 00:45:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAdAUtiL6DwJDWLLmUqct6B6n7Zaa2DyPhpwKZKb=cpRH+8+vQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 21/06/21 19:46, Jing Zhang wrote:
>> const struct kvm_stats_header kvm_vm_stats_header = {
>>          .name_size = KVM_STATS_NAME_SIZE,
>>          .num_desc = num_desc,
> The problem is how we calculate the number of descriptors, which needs the
> size of the descriptor array for each architecture.
> Define another global variable to export the size of descriptor array?

Pass it as an argument?

Paolo

