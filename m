Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BB91B2E74
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Apr 2020 19:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbgDURju (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Apr 2020 13:39:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59458 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725987AbgDURju (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Apr 2020 13:39:50 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LHZH5o106524
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Apr 2020 13:39:38 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30gc2xdc1a-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Apr 2020 13:39:38 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <ldufour@linux.ibm.com>;
        Tue, 21 Apr 2020 18:38:52 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 Apr 2020 18:38:48 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03LHdV8u2883916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 17:39:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCB05A405B;
        Tue, 21 Apr 2020 17:39:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EDCEA4054;
        Tue, 21 Apr 2020 17:39:31 +0000 (GMT)
Received: from pomme.local (unknown [9.145.149.94])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Apr 2020 17:39:31 +0000 (GMT)
Subject: Re: [PATCH] KVM: PPC: Book3S HV: read ibm,secure-memory nodes
To:     "Oliver O'Halloran" <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     kvm-ppc@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20200416162715.45846-1-ldufour@linux.ibm.com>
 <87k129gdx8.fsf@mpe.ellerman.id.au>
 <CAOSf1CF2YEG1U_1XP_Vvk3Bn1RCiNa1DAKEbemWu00JimoPsUQ@mail.gmail.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Date:   Tue, 21 Apr 2020 19:39:31 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAOSf1CF2YEG1U_1XP_Vvk3Bn1RCiNa1DAKEbemWu00JimoPsUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042117-4275-0000-0000-000003C4150D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042117-4276-0000-0000-000038D99A6F
Message-Id: <db211c9c-3e6c-761c-8c9f-4110d3c0fcbe@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_07:2020-04-21,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=998
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004210136
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Le 21/04/2020 à 15:43, Oliver O'Halloran a écrit :
> On Tue, Apr 21, 2020 at 11:37 PM Michael Ellerman <mpe@ellerman.id.au> wrote:
>>
>> Hi Laurent,
>>
>> Laurent Dufour <ldufour@linux.ibm.com> writes:
>>> The newly introduced ibm,secure-memory nodes supersede the
>>> ibm,uv-firmware's property secure-memory-ranges.
>>
>> Is either documented in a device tree binding document anywhere?
>>
>> cheers
>>
>>> Firmware will no more expose the secure-memory-ranges property so first
>>> read the new one and if not found rollback to the older one.
> 
> There's some in Ryan's UV support series for skiboot:
> 
> https://patchwork.ozlabs.org/project/skiboot/patch/20200227204023.22125-2-grimm@linux.ibm.com/
> 
> ...which is also marked RFC. Cool.

Thanks Oliver for this pointer.

Yes this is an RFC but this documentation details the secure memory nodes 
created by skiboot and parsed by this patch.

Michael, is that enough for you?

Laurent.

