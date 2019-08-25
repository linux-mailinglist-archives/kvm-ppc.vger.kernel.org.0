Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A95E49C151
	for <lists+kvm-ppc@lfdr.de>; Sun, 25 Aug 2019 04:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfHYCTc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 24 Aug 2019 22:19:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11408 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727950AbfHYCTc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 24 Aug 2019 22:19:32 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7P2H8vA071029;
        Sat, 24 Aug 2019 22:19:24 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uk1chnna7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 24 Aug 2019 22:19:24 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7P2I9pY072935;
        Sat, 24 Aug 2019 22:19:24 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uk1chnna0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 24 Aug 2019 22:19:24 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7P2Fk5E019438;
        Sun, 25 Aug 2019 02:19:23 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02wdc.us.ibm.com with ESMTP id 2ujvv64ywy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 25 Aug 2019 02:19:23 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7P2JN3Y48103776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Aug 2019 02:19:23 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12EF1AE05C;
        Sun, 25 Aug 2019 02:19:23 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3BE3AE05F;
        Sun, 25 Aug 2019 02:19:20 +0000 (GMT)
Received: from [9.80.232.108] (unknown [9.80.232.108])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 25 Aug 2019 02:19:20 +0000 (GMT)
Subject: Re: [PATCH v2] powerpc/powernv: Add ultravisor message log interface
To:     Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        "Oliver O'Halloran" <oohall@gmail.com>
References: <20190823060654.28842-1-cclaudio@linux.ibm.com>
 <87o90g3v5o.fsf@concordia.ellerman.id.au>
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
Message-ID: <4e577a36-4ce1-410b-3ceb-d31bbf564b3d@linux.ibm.com>
Date:   Sat, 24 Aug 2019 23:19:19 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <87o90g3v5o.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-25_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908250023
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 8/23/19 9:48 AM, Michael Ellerman wrote:
> Hi Claudio,

Hi Michael,

>
> Claudio Carvalho <cclaudio@linux.ibm.com> writes:
>> Ultravisor (UV) provides an in-memory console which follows the OPAL
>> in-memory console structure.
>>
>> This patch extends the OPAL msglog code to also initialize the UV memory
>> console and provide a sysfs interface (uv_msglog) for userspace to view
>> the UV message log.
>>
>> CC: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
>> CC: Oliver O'Halloran <oohall@gmail.com>
>> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
>> ---
>> This patch depends on the "kvmppc: Paravirtualize KVM to support
>> ultravisor" patchset submitted by Claudio Carvalho.
>> ---
>>  arch/powerpc/platforms/powernv/opal-msglog.c | 99 ++++++++++++++------
>>  1 file changed, 72 insertions(+), 27 deletions(-)
> I think the code changes look mostly OK here.
>
> But I'm not sure about the end result in sysfs.
>
> If I'm reading it right this will create:
>
>  /sys/firmware/opal/uv_msglog
>
> Which I think is a little weird, because the UV is not OPAL.
>
> So I guess I wonder if the file should be created elsewhere to avoid any
> confusion and keep things nicely separated.
>
> Possibly /sys/firmware/ultravisor/msglog ?


Yes, makes sense. I will do that.

Currently, the ultravisor memory console DT property is in
/ibm,opal/ibm,opal-uv-memcons. I think we should move it to
/ibm,ultravisor/ibm,uv-firmware/ibm,uv-memcons. What do you think?

Thanks,
Claudio


>
> cheers
